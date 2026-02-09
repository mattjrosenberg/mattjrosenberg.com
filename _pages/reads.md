---
layout: page
title: reads
permalink: /reads
---

<ul class="archive">
{% assign link_posts = site.posts | where_exp: "post", "post.link" %}
{% for post in link_posts %}
<li>
  <a href="{{ post.url }}" class="internal-link">{{ post.title }}</a>
  <span>{{ post.link | split: '//' | last | split: '/' | first }} &middot; {{ post.date | date: "%B %-d, %Y" }}</span>
  {% if post.summary %}<p>{{ post.summary }}</p>{% endif %}
</li>
{% endfor %}
</ul>
