---
layout: page
title: blog
permalink: /blog
---
<ul class="archive">
{% for post in site.posts %}
{% unless post.link %}
<li>
  <a href="{{ post.url }}" class="internal-link">{{ post.title }}</a>
  <span>{{ post.date | date: "%B %-d, %Y" }}</span>
</li>
{% endunless %}
{% endfor %}
</ul>
