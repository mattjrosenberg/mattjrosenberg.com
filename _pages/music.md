---
layout: page
title: music
permalink: /music
---
{% assign music_posts = site.posts | where: "type", "music" %}
{% for post in music_posts %}
<article class="read-entry">
  <header>
    <h2><a href="{{ post.url }}" class="internal-link">{{ post.title }}</a></h2>
    <p class="read-meta">
      <a href="{{ post.url }}" class="read-permalink internal-link"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time></a>
    </p>
  </header>
  <div class="read-content">{{ post.content }}</div>
</article>
{% endfor %}
