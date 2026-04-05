---
layout: page
title: music
permalink: /music
---
I write a weekly post about music I've been listening to. I also keep a [running 2026 playlist on Spotify](https://open.spotify.com/playlist/64tc1MczjjFQgEFI8v8Vek).

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
