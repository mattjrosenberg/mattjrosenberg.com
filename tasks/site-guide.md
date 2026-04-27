# Site Guide

How to create and publish content on mattjrosenberg.com from Obsidian.

## Contents

- [Vault Setup](#vault-setup)
- [Content Types](#content-types)
- [Writing Content](#writing-content)
- [Adding a Photography Gallery](#adding-a-photography-gallery)
- [Publishing Workflow](#publishing-workflow)
- [Folders Excluded from Build](#folders-excluded-from-build)
- [Image Handling Summary](#image-handling-summary)

---

## Vault Setup

The site repo at `/Users/mrosenberg/Documents - Local/mattjrosenberg.com/` is an Obsidian vault. Open it as a vault in Obsidian (separate from your main knowledge vault).

**Community plugins installed:**
- **Obsidian Git** — commit and push from within Obsidian
- **Templater** — template-driven note creation with prompts, auto-naming, auto-filing
- **QuickAdd** — macro execution (e.g. photography image conversion)

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

Blog posts. Filename must be `YYYY-MM-DD-slug.md`. URL: `/{year}/{month}/{day}/{slug}`

Template: `obsidian-templates/post.md` (Templater-powered — auto-renames file)

```yaml
---
title: My Post
date: 2026-02-08
tags: []
summary:
image:
---
```

- `summary` appears under the post title on the blog index
- `image` sets the header image on the post page and the OG preview image when sharing the link

### Links (`_posts/` with `type: link`)

Link posts for sharing articles with commentary. Aggregate on `/links`.

Template: `obsidian-templates/link.md` (Templater-powered)

```yaml
---
title: Article Title
date: 2026-02-09
layout: post
type: link
link: https://example.com/article
tags: []
summary:
---
```

### Music Posts (`_posts/` with `type: music`)

Weekly music roundup posts. Aggregate on `/music`. Generated automatically from the main vault via the QuickAdd "Generate Music Post" macro.

Template: `obsidian-templates/music.md`

```yaml
---
title: "new (good) music"
date: 2026-04-25
layout: link-post
type: music
tags: []
---
```

### Pages (`_pages/`)

Structural pages (blog index, music index, links index, etc.). URL: `/{slug}`

---

## Writing Content

Write normally in Obsidian. The Jekyll plugins handle:

- **Wikilinks**: `[[page-title]]` becomes an HTML link with backlinks tracked
- **Images (no path)**: `![alt](photo.jpg)` auto-prefixes `/assets/images/`
- **Images (full path)**: `![alt](/assets/images/...)` processed normally — WebP wrapping and lazy loading applied
- **Obsidian embeds**: `![[photo.jpg]]` becomes an `<img>` tag
- **WebP wrapping**: all JPEG images get wrapped in `<picture>` with WebP `<source>` automatically
- **Adjacent images**: two image links on consecutive lines (no blank line) render side-by-side
- **Full-width images**: a single image line with blank lines before/after renders full width
- **External links**: automatically open in new tabs

### Important: Raw HTML links

`<a href="/path">` links in raw HTML are not clickable inside Obsidian's editor — they only work on the live site. Photography gallery index cards use raw HTML, so edit those by finding the file in the explorer directly.

---

## Adding a Photography Gallery

### 1. Prepare the folder and files

- Create a folder: `assets/images/photography/{name}/` — use hyphens, no spaces (e.g. `mexico-city`)
- Name images: `{name}_1.jpg`, `{name}_2.jpg`, etc. (e.g. `mexico-city_1.jpg`)
- Drop your JPEGs in

### 2. Convert images

Run the **"Convert Photography Images"** QuickAdd macro. It will:
- Find all JPEGs in `assets/images/photography/` that don't have a matching `.webp`
- Resize each to 1600px max width
- Convert to WebP at quality 80

No terminal needed.

### 3. Create the gallery page

Use the `photography-gallery` Obsidian template or create `_notes/photography/{name}.md` manually:

```markdown
---
title: london
permalink: /photography/london
hide_title: true
hide_backlinks: true
---

# London

![London 1](/assets/images/photography/london/london_1.jpg)

![London 2](/assets/images/photography/london/london_2.jpg)
![London 3](/assets/images/photography/london/london_3.jpg)

![London 4](/assets/images/photography/london/london_4.jpg)
```

**Layout rules:**
- Single image with blank lines before/after → full width
- Two images on consecutive lines (no blank line between) → side by side
- The plugin auto-groups pairs and wraps them — no `<div class="img-grid">` needed

### 4. Add a card to the gallery index

Edit `_notes/photography.md` and add inside the `<div class="gallery-index">` block:

```html
<a class="gallery-card internal-link" href="/photography/london">
  <img src="/assets/images/photography/london/london_1.jpg" alt="London">
  <span>London</span>
</a>
```

### 5. Commit and push

---

## Publishing Workflow

1. Write or edit content in Obsidian
2. Commit and push via Obsidian Git (or terminal)
3. Netlify auto-builds and deploys on push (~60 seconds)

**Protected files** (`_config.yml`, `netlify.toml`) have `skip-worktree` set so Obsidian Git won't overwrite them. To change them, edit and commit manually via terminal.

---

## Folders Excluded from Build

These exist in the vault but are not published to the live site:

- `.obsidian/` — Obsidian config and plugins
- `.claude/` — Claude Code worktrees (hidden from Obsidian file explorer)
- `obsidian-templates/` — templates for new content
- `tasks/` — project files, scripts, and this guide
- `vendor/` — Ruby gem dependencies (hidden from Obsidian file explorer)
- `_site/` — Jekyll build output, auto-generated (hidden from Obsidian file explorer)

---

## Image Handling Summary

| What you write | What happens |
|---|---|
| `![alt](photo.jpg)` | Plugin adds `/assets/images/` prefix, lazy loading, `<picture>` + WebP |
| `![alt](/assets/images/photo.jpg)` | Plugin adds lazy loading, `<picture>` + WebP |
| `![[photo.jpg]]` | Plugin converts to `<img>`, adds path, lazy loading, `<picture>` + WebP |
| Two image lines, no blank line | Plugin auto-wraps both in `<div class="img-grid">` (side-by-side) |
| `data-hero` on `<img>` | Responsive hero with 800w/1600w srcset, fetchpriority="high" |
| `avatar.jpg` | Skipped — no WebP wrapping |
