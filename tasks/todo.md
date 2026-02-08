# Jekyll Migration Project

Migrate mattjrosenberg.com from Obsidian Publish to Jekyll + Netlify for full CSS/HTML control.

**Why:** Obsidian Publish's `app.css` makes custom theming (eink aesthetic, toggle, nav indicators) a constant `!important` battle. Jekyll gives us full ownership of the markup.

**Stack:** Jekyll (static site generator) + Obsidian Git (auto-push) + Netlify (hosting) + Cloudflare (security, unchanged)

---

## Phase 1: Infrastructure Setup -- COMPLETE

- [x] Create GitHub repo -- [mattjrosenberg/mattjrosenberg.com](https://github.com/mattjrosenberg/mattjrosenberg.com)
- [x] Fork Green Web Template (Obsidian compatibility: wikilinks, backlinks, graph, image embeds)
- [x] Configure Jekyll (`_config.yml`, folder structure, Gemfile)
- [x] Sign up for Netlify, connect repo, set build command (`jekyll build`)
- [x] Install Obsidian Git plugin, configure auto-push
- [x] Test: push a sample note and confirm it builds on Netlify

---

## Phase 2: Theme & Design -- COMPLETE

- [x] Build eink theme in pure CSS (full control, no `app.css` fighting)
- [x] Custom pill toggle with sun/moon icons
- [x] Image grid + lightbox (custom JS lightbox, `.img-grid` CSS grids)
- [x] Nav with active page indicator (vertical bar + bold)
- [x] Responsive/mobile layout (hamburger menu)
- [x] Footer -- kept as-is (we own it now)

---

## Phase 3: Content Migration -- COMPLETE

- [x] Frontmatter auto-injected by `empty_front_matter_note_injector.rb` plugin
- [x] Obsidian image syntax converted at build time by `obsidian_images_generator.rb`
- [x] Folder structure in place (`_notes/`, `assets/`)
- [x] Existing pages render correctly
- [x] Verify photography pages (paris, italy, nyc, tokyo) with image grids
- [x] Verify lightbox/zoom still works

---

## Phase 4: Feature Parity -- COMPLETE

- [x] Wikilinks -- handled by `bidirectional_links_generator.rb`
- [x] Backlinks -- handled by `bidirectional_links_generator.rb`, displayed in note layout
- [x] Callouts (`> [!note]` syntax) -- `obsidian_callouts.rb` plugin + CSS
- [x] Dark/light toggle with persistence
- [ ] ~Graph view -- code ready, eink-styled. Deferred (enable via config later)~
- [ ] ~Search -- deferred (add Pagefind when more content exists)~

---

## Phase 5: Go Live

- [ ] Final review of all pages on Netlify preview URL
- [x] Code simplify plugin run
- [x] Security review (first pass -- see findings below)
- [ ] Disclose how the website was built in About page
- [ ] Create an open-source version?
- [ ] Update Cloudflare DNS: point mattjrosenberg.com to Netlify
- [ ] Set Cloudflare SSL to "Full (Strict)"
- [ ] Verify site loads on mattjrosenberg.com with HTTPS
- [ ] Cancel Obsidian Publish subscription

---

## What You Gain

- Full HTML/CSS/JS control (no more `!important` wars)
- Free hosting (Netlify free tier) -- saves $8/month Obsidian Publish fee
- Version history via Git
- Ability to add anything (analytics, contact forms, custom pages)
- Cloudflare security unchanged

## What You Lose

- One-click publishing (replaced by auto-push via Obsidian Git -- nearly as easy)
- Hover preview popups (available in template but may need tweaking)
- Stacked/sliding panes (niche feature, rarely used)

---

## Reference

- [Kepano's approach](https://stephango.com/vault) -- Jekyll + Obsidian Git + Netlify
- [Green Web Template](https://github.com/meewgumi/green-web-template) -- starting template
- [Maxime Vaillancourt's Digital Garden](https://github.com/maximevaillancourt/digital-garden-jekyll-template) -- upstream template
- [Obsidian Git plugin](https://github.com/Vinzent03/obsidian-git)
- [Netlify docs](https://docs.netlify.com/)

---

## Security Findings

### High
- [ ] Update Gemfile.lock dependencies (`bundle update`) -- nokogiri, rexml, addressable have known CVEs

### Medium
- [ ] Add security headers to `netlify.toml` (CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy)
- [ ] Add `Regexp.escape()` to note title interpolation in `bidirectional_links_generator.rb`
- [ ] HTML-escape callout title/type in `obsidian_callouts.rb`
- [ ] HTML-escape href in generated anchor tags in `bidirectional_links_generator.rb`
- [ ] Replace `innerHTML` with safer DOM methods in `link-previews.html`
- [ ] Add `| escape` filter to `page.title` in `<meta>` attributes in `head.html`

### Low
- [ ] Fix `target="blank"` to `target="_blank"` + add `rel="noopener noreferrer"` in `open_external_links_in_new_tab.rb`
- [ ] HTML-escape image filenames in `obsidian_images_generator.rb`
- [ ] Escape `page.favicon` in SVG data URI in `head.html`
- [ ] Escape `page.category` in `note.html`
- [ ] Update Ruby version in `netlify.toml` (3.1 is past EOL)
