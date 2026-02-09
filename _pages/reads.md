---
layout: page
title: reads
permalink: /reads
---

{% assign link_posts = site.posts | where_exp: "post", "post.link" %}
{% for post in link_posts %}
<article class="read-entry">
  <header>
    <h2><a href="{{ post.link }}" target="_blank" rel="noopener">{{ post.title }} &rarr;</a></h2>
    <p class="read-meta">
      <span class="link-source">{{ post.link | split: '//' | last | split: '/' | first }}</span>
      &middot;
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time>
      &middot;
      <a href="{{ post.url }}" class="read-permalink internal-link">#</a>
    </p>
  </header>
  <div class="read-content">{{ post.content }}</div>
</article>
{% endfor %}
