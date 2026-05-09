<%*
const date = tp.date.now("YYYY-MM-DD");
const filename = `${date}-new-good-music`;
await tp.file.rename(filename);
await tp.file.move(`_posts/${filename}`);
-%>
---
title: "new (good) music"
date: <% date %>
layout: link-post
type: music
image: ""
tags: []
---


