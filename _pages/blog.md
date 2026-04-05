---
layout: page
title: blog
permalink: /blog
---
<ul class="archive">
{% for post in site.posts %}
{% unless post.type == "link" or post.type == "music" %}
<li>
  <a href="{{ post.url }}" class="internal-link">{{ post.title }}</a>
  <span>{{ post.date | date: "%B %-d, %Y" }}</span>
  {% if post.summary %}<p>{{ post.summary }}</p>{% endif %}
</li>
{% endunless %}
{% endfor %}
</ul>
