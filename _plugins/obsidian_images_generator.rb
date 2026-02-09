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
    end
  end
end
