---
layout: note
title: welcome
id: home
hide_title: true
hide_backlinks: true
---

![Hero](/assets/images/000555910013.jpg)

# Matt Rosenberg

I'm Matt Rosenberg, a comms guy who loves helping brands tell great stories, handle tough moments, and get noticed.

Reading every technology review while studying in DC led me to follow my passion into the industry. Since then, I've managed to combine both policy and tech into a career elevating the great work technologists do.

My work has taken me everywhere from Tokyo to Tel Aviv, and I'm always looking for the next story worth telling. Stick around, read a bit, and let's connect.

[More about me](/about) · [Resume](/resume) · [Email Me](mailto:mattjrosenberg@gmail.com)

{% if site.posts.size > 0 %}
## Recent

<ul class="archive">
{% for post in site.posts limit:3 %}
<li>
  <a href="{{ post.url }}" class="internal-link">{{ post.title }}</a>
  <span>{{ post.date | date: "%B %-d, %Y" }}</span>
</li>
{% endfor %}
</ul>

[All posts](/blog)
{% endif %}
