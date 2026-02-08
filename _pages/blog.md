---
layout: page
title: blog
permalink: /blog
---

<ul class="archive">
{% for post in site.posts %}
<li>
  <a href="{{ post.url }}" class="internal-link">{{ post.title }}</a>
  <span>{{ post.date | date: "%B %-d, %Y" }}</span>
</li>
{% endfor %}
</ul>
