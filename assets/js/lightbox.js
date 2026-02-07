document.addEventListener("DOMContentLoaded", function () {
  var article = document.querySelector("article");
  if (!article) return;

  article.addEventListener("click", function (e) {
    if (e.target.tagName !== "IMG") return;

    var overlay = document.createElement("div");
    overlay.className = "lightbox";

    var img = document.createElement("img");
    img.src = e.target.src;
    img.alt = e.target.alt;
    overlay.appendChild(img);

    document.body.appendChild(overlay);
    document.body.style.overflow = "hidden";

    function close() {
      overlay.remove();
      document.body.style.overflow = "";
    }

    overlay.addEventListener("click", close);

    document.addEventListener("keydown", function handler(e) {
      if (e.key === "Escape") {
        close();
        document.removeEventListener("keydown", handler);
      }
    });
  });
});
