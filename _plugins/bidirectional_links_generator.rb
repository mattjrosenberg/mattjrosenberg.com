# frozen_string_literal: true
require 'cgi'

class BidirectionalLinksGenerator < Jekyll::Generator
  CODEBLOCK_EXCLUSION = '(?!.*?[\r\n]+[`{3,}|~{3,}])'
  WIKILINK_PATTERN = /\[\[([^\]|]+)(?:\|[^\]]+)?\]\]/

  def generate(site)
    graph_nodes = []
    graph_edges = []
    reference_nodes = {}

    all_notes = site.collections['notes'].docs
    all_pages = site.collections['pages'].docs
    all_posts = site.posts.docs
    all_docs = all_notes + all_pages + all_posts
    link_ext = site.config["use_html_extension"] ? '.html' : ''

    # Pre-pass: extract wikilinks before transformation
    doc_wikilinks = {}
    all_docs.each do |doc|
      links = doc.content.scan(WIKILINK_PATTERN).flatten.map(&:strip)
      doc_wikilinks[doc] = links
    end

    # Resolve wikilinks to internal-link anchors
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

        current_note.content = current_note.content.gsub(
          /\[\[#{escaped_filename}\|(.+?)(?=\])\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
        )
        if escaped_data
          current_note.content = current_note.content.gsub(
            /\[\[#{escaped_data}\|(.+?)(?=\])\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
          )
        end

        if escaped_data
          current_note.content = current_note.content.gsub(
            /\[\[(#{escaped_data})\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
          )
        end
        current_note.content = current_note.content.gsub(
          /\[\[(#{escaped_filename})\]\]#{CODEBLOCK_EXCLUSION}/i, anchor
        )
      end

      # Mark remaining unresolved links
      current_note.content = current_note.content.gsub(
        /
          (?:^\[{2}.|\s{1}\[{2})
          ([^\]]+)
          \]{2}
          #{CODEBLOCK_EXCLUSION}
        /x,
        <<~HTML.chomp
          <span class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span></span>
        HTML
      )
    end

    # Graph: notes with backlinks (existing behaviour)
    all_notes.each do |current_note|
      backlinks = all_notes.filter { |n| n.content.include?(current_note.url) }
      current_note.data['backlinks'] = backlinks

      unless current_note.path.include?('_notes/index.html')
        graph_nodes << {
          id: note_id(current_note),
          path: "#{current_note.url}#{link_ext}",
          label: current_note.data['title'],
          type: 'note',
        }
      end

      backlinks.each do |n|
        graph_edges << {
          source: note_id(n),
          target: note_id(current_note),
        }
      end
    end

    # Graph: posts and their wikilink connections
    all_posts.each do |post|
      post_node_id = note_id(post)
      graph_nodes << {
        id: post_node_id,
        path: "#{post.url}#{link_ext}",
        label: post.data['title'] || File.basename(post.basename, '.md'),
        type: 'post',
      }

      (doc_wikilinks[post] || []).uniq.each do |link_name|
        clean_name = link_name.strip

        # Skip pipe aliases and empty
        next if clean_name.empty? || clean_name.include?('|')

        # Check if resolves to an existing note
        resolved = all_notes.find do |n|
          n.data['title']&.downcase == clean_name.downcase ||
          File.basename(n.basename, File.extname(n.basename)).gsub('_', ' ').downcase == clean_name.downcase
        end

        if resolved
          graph_edges << { source: post_node_id, target: note_id(resolved) }
        else
          ref_id = ref_node_id(clean_name)
          unless reference_nodes[ref_id]
            reference_nodes[ref_id] = true
            graph_nodes << {
              id: ref_id,
              path: nil,
              label: clean_name,
              type: 'reference',
            }
          end
          graph_edges << { source: post_node_id, target: ref_id }
        end
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

  def ref_node_id(name)
    "ref_#{name.gsub(/\W+/, '_').downcase}"
  end
end
