<%*
const title = await tp.system.prompt("Title");
const link = await tp.system.prompt("Link URL");
const date = tp.date.now("YYYY-MM-DD");
const slug = title.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
const filename = `${date}-${slug}`;
await tp.file.rename(filename);
await tp.file.move(`_posts/${filename}`);
-%>
---
title: "<% title %>"
date: <% date %>
layout: link-post
link: <% link %>
tags: []
slug: <% slug %>
---

