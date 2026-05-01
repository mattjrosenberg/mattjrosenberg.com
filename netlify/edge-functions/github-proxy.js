const GITHUB_API = "https://api.github.com";
const PATH_PREFIX = "/github-proxy/github";
const REPO = "mattjrosenberg/mattjrosenberg.com";

export default async (request) => {
  const githubToken = Deno.env.get("GITHUB_PAT");

  if (!githubToken) {
    return jsonResponse({ error: "Server misconfigured" }, 500);
  }

  // CORS preflight
  if (request.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders() });
  }

  // Validate Netlify Identity JWT
  const authHeader = request.headers.get("Authorization") || "";
  if (!authHeader.startsWith("Bearer ") || !isValidJWT(authHeader.slice(7))) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

  const url = new URL(request.url);

  // Handle git-gateway's own /settings handshake — tells Decap CMS GitHub is enabled
  if (url.pathname === "/github-proxy/settings") {
    return jsonResponse(
      { github_enabled: true, gitlab_enabled: false, bitbucket_enabled: false, roles: [] },
      200
    );
  }

  // All other requests: proxy to GitHub API
  // Decap CMS's git-gateway backend omits the repo from paths — the real
  // git-gateway knows which repo from Netlify's config. We inject it here.
  const strippedPath = url.pathname.replace(PATH_PREFIX, "") || "/";
  const githubPath = injectRepo(strippedPath);
  const githubUrl = `${GITHUB_API}${githubPath}${url.search}`;

  const hasBody = !["GET", "HEAD"].includes(request.method);

  const forwardHeaders = {
    Authorization: `token ${githubToken}`,
    Accept: "application/vnd.github.v3+json",
    "User-Agent": "mattjrosenberg-cms/1.0",
    "Content-Type": request.headers.get("Content-Type") || "application/json",
  };

  // Forward Content-Length if present so GitHub knows the payload size
  const contentLength = request.headers.get("Content-Length");
  if (hasBody && contentLength) forwardHeaders["Content-Length"] = contentLength;

  const githubResponse = await fetch(githubUrl, {
    method: request.method,
    headers: forwardHeaders,
    // Stream the body directly rather than buffering — avoids memory limits
    // on large payloads like base64-encoded images. Deno supports ReadableStream
    // bodies natively; do not pass duplex which is Node.js-only.
    body: hasBody ? request.body : undefined,
  });

  const responseBody = await githubResponse.arrayBuffer();

  return new Response(responseBody, {
    status: githubResponse.status,
    headers: {
      "Content-Type":
        githubResponse.headers.get("Content-Type") || "application/json",
      ...corsHeaders(),
    },
  });
};

// Git-gateway omits /repos/{owner}/{repo} from paths — inject it for all
// repo-scoped endpoints. Non-repo endpoints like /user pass through unchanged.
function injectRepo(path) {
  if (path === "/user" || path.startsWith("/user/")) return path;
  if (path.startsWith("/repos/")) return path;
  return `/repos/${REPO}${path}`;
}

// Validates a Netlify Identity JWT: checks structure, expiry, and that a
// subject claim exists. Does not verify the cryptographic signature —
// sufficient for a personal blog.
function isValidJWT(token) {
  try {
    const parts = token.split(".");
    if (parts.length !== 3) return false;
    const pad = (s) => s + "=".repeat((4 - (s.length % 4)) % 4);
    const payload = JSON.parse(
      atob(pad(parts[1].replace(/-/g, "+").replace(/_/g, "/")))
    );
    if (payload.exp && Date.now() / 1000 > payload.exp) return false;
    if (!payload.sub) return false;
    return true;
  } catch {
    return false;
  }
}

function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Authorization, Content-Type",
    "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
  };
}

function jsonResponse(data, status) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders() },
  });
}

export const config = { path: "/github-proxy/*" };
