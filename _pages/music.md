---
layout: page
title: music
permalink: /music
---
<iframe style="border-radius:12px" src="https://open.spotify.com/embed/playlist/64tc1MczjjFQgEFI8v8Vek" width="100%" height="352" frameBorder="0" allowfullscreen="" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>

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
