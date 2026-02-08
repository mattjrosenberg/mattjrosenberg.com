# frozen_string_literal: true
require 'cgi'

class BidirectionalLinksGenerator < Jekyll::Generator
  CODEBLOCK_EXCLUSION = '(?!.*?[\r\n]+[`{3,}|~{3,}])'

  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_notes = site.collections['notes'].docs
    all_pages = site.collections['pages'].docs
    all_docs = all_notes + all_pages
    link_ext = site.config["use_html_extension"] ? '.html' : ''

    all_docs.each do |current_note|
      all_docs.each do |target|
        filename_title = File.basename(
          target.basename, File.extname(target.basename)
        ).gsub('_', ' ').capitalize
        data_title = target.data['title']

        href = CGI.escapeHTML("#{target.url}#{link_ext}")
        anchor = "<a class='internal-link' href='#{href}'>\\1</a>"

        escaped_filename = Regexp.escape(filename_title)
        escaped_data = Regexp.escape(data_title) if data_title

        # [[Title|display text]] - match by filename then by front matter title
        current_note.content = current_note.content.gsub(
          /\[\[#{escaped_filename}\|(.+?)(?=\])\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
        )
        if escaped_data
          current_note.content = current_note.content.gsub(
            /\[\[#{escaped_data}\|(.+?)(?=\])\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
          )
        end

        # [[Title]] - match by front matter title then by filename
        if escaped_data
          current_note.content = current_note.content.gsub(
            /\[\[(#{escaped_data})\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
          )
        end
        current_note.content = current_note.content.gsub(
          /\[\[(#{escaped_filename})\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
        )
      end

      # Turn remaining unresolved [[links]] into greyed-out invalid markers
      current_note.content = current_note.content.gsub(
        /
          (?:^\[{2}.|\s{1}\[{2})  # [[ at start of line or after space
          ([^\]]+)                 # capture link text
          \]{2}                    # closing ]]
          #{CODEBLOCK_EXCLUSION}   # exclude codeblocks
        /x,
        <<~HTML.chomp
          <span title='There is no note that matches this link.' class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span></span>
        HTML
      )
    end

    # Build backlinks and graph data
    all_notes.each do |current_note|
      backlinks = all_notes.filter { |n| n.content.include?(current_note.url) }
      current_note.data['backlinks'] = backlinks

      unless current_note.path.include?('_notes/index.html')
        graph_nodes << {
          id: note_id(current_note),
          path: "#{current_note.url}#{link_ext}",
          label: current_note.data['title'],
        }
      end

      backlinks.each do |n|
        graph_edges << {
          source: note_id(n),
          target: note_id(current_note),
        }
      end
    end

    File.write('_includes/notes_graph.json', JSON.dump({
      edges: graph_edges,
      nodes: graph_nodes,
    }))
  end

  private

  def note_id(note)
    note.data['title'].dup.gsub(/\W+/, ' ').delete(' ').to_i(36).to_s
  end
end
