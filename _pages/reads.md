---
layout: page
title: links
permalink: /links
---
{% assign read_posts = site.posts | where: "type", "read" %}
{% for post in read_posts %}
<article class="read-entry">
  <header>
    {% if post.link %}
    <h2><a href="{{ post.link }}" target="_blank" rel="noopener">{{ post.title }} &rarr;</a></h2>
    <p class="read-meta">
      <span class="link-source">{{ post.link | split: '//' | last | split: '/' | first }}</span>
      &middot;
      <a href="{{ post.url }}" class="read-permalink internal-link"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time></a>
    </p>
    {% else %}
    <h2><a href="{{ post.url }}" class="internal-link">{{ post.title }}</a></h2>
    <p class="read-meta">
      <a href="{{ post.url }}" class="read-permalink internal-link"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time></a>
    </p>
    {% endif %}
  </header>
  <div class="read-content">{{ post.content }}</div>
</article>
{% endfor %}
