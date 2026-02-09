# Site Guide

How to create and publish content on mattjrosenberg.com from Obsidian.

---

## Vault Setup

The site repo at `/Users/mrosenberg/mattjrosenberg.com` is an Obsidian vault. Open it as a vault in Obsidian (separate from your main knowledge vault).

**Obsidian Git** is installed for commit/push from within Obsidian. You can also use the terminal.

---

## Content Types

### Notes (`_notes/`)

General pages (about, photography galleries, etc.). URL: `/{slug}`

Template: `obsidian-templates/note.md`

```yaml
---
title: my-note
category:
favicon:
---
```

### Posts (`_posts/`)

Blog posts. Filename must be `YYYY-MM-DD-slug.md`. URL: `/{year}/{month}/{slug}`

Template: `obsidian-templates/post.md`

```yaml
---
title: My Post
date: 2026-02-08
tags: []
summary:
slug: my-post
---
```

### Pages (`_pages/`)

Structural pages (archive, blog index). URL: `/{slug}`

Template: `obsidian-templates/page.md`

```yaml
---
title: my-page
layout: page
id:
favicon:
---
```

---

## Writing Content

Write normally in Obsidian. The Jekyll plugins handle:

- **Wikilinks**: `[[page-title]]` or `[[page-title|Display Text]]` become HTML links with backlinks
- **Images without path**: `![alt](photo.jpg)` auto-prefixes `/assets/images/`
- **Obsidian embeds**: `![[photo.jpg]]` becomes an `<img>` tag
- **Callouts**: `> [!note] Title` renders as styled callout blocks
- **External links**: automatically open in new tabs
- **WebP wrapping**: all JPEG `<img>` tags get wrapped in `<picture>` with WebP `<source>` automatically

Images go in `assets/images/`. The plugin adds lazy loading to all images unless `loading="eager"` is set.

### Important: Raw HTML links

`<a href="/path">` links in raw HTML are **not** clickable inside Obsidian's editor. They only work on the live site. This is a known limitation -- Obsidian only navigates `[[wikilinks]]`.

The photography gallery index uses raw HTML for the card layout, so those links won't navigate in Obsidian. Edit gallery pages by finding them in the file explorer instead.

---

## Adding a Photography Gallery

### 1. Prepare images

Drop images into `assets/images/photography/{name}/` (e.g., `london`).

From the terminal, resize and convert:

```bash
cd /Users/mrosenberg/mattjrosenberg.com

# Resize to 1600px max width and compress
for f in assets/images/photography/{name}/*.{jpg,JPG,jpeg}; do
  sips --resampleWidth 1600 "$f"
  sips -s formatOptions 80 "$f"
done

# Convert to WebP
for f in assets/images/photography/{name}/*.{jpg,JPG,jpeg}; do
  cwebp -q 80 "$f" -o "${f%.*}.webp"
done
```

### 2. Create the gallery page

Use the `photography-gallery` template (Insert template > photography-gallery) or create manually:

**File:** `_notes/photography/{name}.md`

```markdown
---
title: london
permalink: /photography/london
hide_title: true
hide_backlinks: true
---

# London

![London 1](/assets/images/photography/london/london_1.jpg)

<div class="img-grid">
  <img src="/assets/images/photography/london/london_2.jpg" alt="London 2">
  <img src="/assets/images/photography/london/london_3.jpg" alt="London 3">
</div>

<div class="img-grid">
  <img src="/assets/images/photography/london/london_4.jpg" alt="London 4">
  <img src="/assets/images/photography/london/london_5.jpg" alt="London 5">
</div>
```

- First image: full width (plain markdown)
- Subsequent images: pairs in `<div class="img-grid">` for side-by-side
- Odd number of images: last one can go solo or in its own grid div
- The plugin auto-wraps all `<img>` tags in `<picture>` with WebP sources and lazy loading

### 3. Add to the gallery index

Edit `_notes/photography.md` and add inside the `<div class="gallery-index">` block:

```html
<a class="gallery-card internal-link" href="/photography/london">
  <img src="/assets/images/photography/london/london_1.jpg" alt="London">
  <span>London</span>
</a>
```

### 4. Commit and push

---

## Publishing Workflow

1. Write or edit content in Obsidian
2. Commit and push (via Obsidian Git or terminal)
3. Netlify auto-builds and deploys on push

---

## Folders Excluded from Build

These exist in the vault but are **not** published to the live site:

- `.obsidian/` -- Obsidian config and plugins
- `obsidian-templates/` -- templates for new content
- `tasks/` -- project task files (including this guide)
- `CLAUDE.md` -- project instructions (if created)

Everything else is built and deployed.

---

## Image Handling Summary

| What you write | What the plugin does |
|---|---|
| `![alt](photo.jpg)` | Adds `/assets/images/` path, lazy loading, `<picture>` + WebP |
| `![[photo.jpg]]` | Converts embed to `<img>`, adds path, lazy loading, `<picture>` + WebP |
| `<img src="/assets/images/..." ...>` | Wraps in `<picture>` + WebP, adds lazy loading if missing |
| `data-hero` attribute on `<img>` | Responsive hero with 800w/1600w srcset, fetchpriority="high" |
| `avatar.jpg` | Skipped (no WebP wrapping) |
