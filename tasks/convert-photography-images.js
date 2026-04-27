module.exports = async (params) => {
  const { app } = params;
  const fs = require("fs");
  const path = require("path");
  const { execSync } = require("child_process");

  const PHOTO_ROOT = "/Users/mrosenberg/Documents - Local/mattjrosenberg.com/assets/images/photography";
  const MAX_WIDTH = 1600;
  const WEBP_QUALITY = 80;

  // Recursively find all JPEGs in the photography folder
  function findJpegs(dir) {
    const results = [];
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        results.push(...findJpegs(fullPath));
      } else if (/\.(jpg|jpeg)$/i.test(entry.name)) {
        results.push(fullPath);
      }
    }
    return results;
  }

  if (!fs.existsSync(PHOTO_ROOT)) {
    new Notice("Photography folder not found.");
    return;
  }

  const jpegs = findJpegs(PHOTO_ROOT);
  const toProcess = jpegs.filter(f => !fs.existsSync(f.replace(/\.(jpg|jpeg)$/i, ".webp")));

  if (toProcess.length === 0) {
    new Notice("All images already have WebP versions.");
    return;
  }

  let converted = 0;
  let errors = [];

  for (const jpeg of toProcess) {
    const webp = jpeg.replace(/\.(jpg|jpeg)$/i, ".webp");
    try {
      // Resize in place to max 1600px (sips only shrinks, won't upscale)
      execSync(`sips -Z ${MAX_WIDTH} "${jpeg}"`, { stdio: "pipe" });
      // Convert to WebP
      execSync(`/opt/homebrew/bin/cwebp -q ${WEBP_QUALITY} "${jpeg}" -o "${webp}"`, { stdio: "pipe" });
      converted++;
    } catch (e) {
      errors.push(path.basename(jpeg));
    }
  }

  const msg = errors.length > 0
    ? `Converted ${converted}/${toProcess.length}. Errors: ${errors.join(", ")}`
    : `Converted ${converted} image${converted !== 1 ? "s" : ""} to WebP.`;

  new Notice(msg);
};
