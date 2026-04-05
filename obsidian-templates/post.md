<%*
  const title = tp.file.title;
  const date = tp.date.now("YYYY-MM-DD");
  const slug = title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
  await tp.file.rename(`${date}-${slug}`);
-%>
---
title: <% title %>
date: <% date %>
layout: post
tags: []
summary:
image:
---
