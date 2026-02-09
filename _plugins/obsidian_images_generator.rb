# frozen_string_literal: true
require 'cgi'

class WikiImages < Jekyll::Generator
  priority :highest

  IMAGE_PATH = "/assets/images/"

  def generate(site)
    all_docs = site.collections['notes'].docs + site.collections['pages'].docs

    all_docs.each do |doc|
      # Markdown images without explicit path: ![alt](file.png "title")
      doc.content = doc.content.gsub(
        /
          !\[([^\]]*)\]        # ![alt text]
          \(                   # opening (
          (?!assets)(?!\/assets)(?!http)  # skip already-pathed or external
          ([^"|')]*?)          # filename
          \s*["|']?([^"|']*)["|']?  # optional title
          \)                   # closing )
          (?!`$)               # exclude codeblocks
        /x
      ) do
        alt = CGI.escapeHTML(Regexp.last_match(1))
        src = CGI.escapeHTML(Regexp.last_match(2))
        title = CGI.escapeHTML(Regexp.last_match(3))
        "<img src=\"#{IMAGE_PATH}#{src}\" alt=\"#{alt}\" title=\"#{title}\" loading=\"lazy\">"
      end

      # Obsidian embeds without path: ![[image.png]]
      doc.content = doc.content.gsub(
        /
          !\[\[                # ![[
          (?!assets)(?!\/assets)  # skip already-pathed
          ([^\]]+)             # filename
          \]\]                 # ]]
          (?!`$)               # exclude codeblocks
        /x
      ) do
        src = CGI.escapeHTML(Regexp.last_match(1))
        "<img src=\"#{IMAGE_PATH}#{src}\" loading=\"lazy\">"
      end

      # Obsidian embeds with explicit path: ![[assets/images/image.png]]
      doc.content = doc.content.gsub(
        /
          !\[\[                # ![[
          ([^\]]+)             # full path
          \]\]                 # ]]
          (?!`$)               # exclude codeblocks
        /x
      ) do
        src = CGI.escapeHTML(Regexp.last_match(1))
        "<img src=\"#{src}\" loading=\"lazy\">"
      end

      # Pass 4: Wrap <img> tags in <picture> with WebP source
      doc.content = doc.content.gsub(
        /<img\s([^>]*src="(\/assets\/images\/[^"]+\.(?:jpg|JPG|jpeg))"[^>]*)>/i
      ) do
        full_attrs = Regexp.last_match(1)
        src = Regexp.last_match(2)

        next "<img #{full_attrs}>" if src.include?('avatar.jpg')

        unless full_attrs.include?('loading=')
          full_attrs += ' loading="lazy"'
        end

        webp_src = src.sub(/\.(?:jpg|JPG|jpeg)$/i, '.webp')

        if full_attrs.include?('data-hero')
          clean_attrs = full_attrs.gsub(/\s*data-hero/, '').strip
          clean_attrs += ' width="1600" height="1060" fetchpriority="high"'
          base = src.sub(/\.(?:jpg|JPG|jpeg)$/i, '')
          ext = src[/\.(?:jpg|JPG|jpeg)$/i]

          "<picture>" \
            "<source srcset=\"#{base}-800.webp 800w, #{base}.webp 1600w\" " \
              "sizes=\"(max-width: 768px) 100vw, 720px\" type=\"image/webp\">" \
            "<source srcset=\"#{base}-800#{ext} 800w, #{base}#{ext} 1600w\" " \
              "sizes=\"(max-width: 768px) 100vw, 720px\" type=\"image/#{ext.delete('.').downcase}\">" \
            "<img #{clean_attrs}>" \
          "</picture>"
        else
          "<picture>" \
            "<source srcset=\"#{webp_src}\" type=\"image/webp\">" \
            "<img #{full_attrs}>" \
          "</picture>"
        end
      end
    end
  end
end
