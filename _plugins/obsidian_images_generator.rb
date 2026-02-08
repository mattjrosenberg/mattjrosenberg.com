# frozen_string_literal: true
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
        /x,
        "<img src=\"#{IMAGE_PATH}\\2\" alt=\"\\1\" title=\"\\3\">"
      )

      # Obsidian embeds without path: ![[image.png]]
      doc.content = doc.content.gsub(
        /
          !\[\[                # ![[
          (?!assets)(?!\/assets)  # skip already-pathed
          ([^\]]+)             # filename
          \]\]                 # ]]
          (?!`$)               # exclude codeblocks
        /x,
        "<img src=\"#{IMAGE_PATH}\\1\">"
      )

      # Obsidian embeds with explicit path: ![[assets/images/image.png]]
      doc.content = doc.content.gsub(
        /
          !\[\[                # ![[
          ([^\]]+)             # full path
          \]\]                 # ]]
          (?!`$)               # exclude codeblocks
        /x,
        '<img src="\1">'
      )
    end
  end
end
