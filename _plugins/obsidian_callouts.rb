# frozen_string_literal: true
class ObsidianCallouts < Jekyll::Generator
  priority :high

  CALLOUT_REGEX = /
    ^>\ ?\[!(\w+)\][-+]?[ ]*(.*)\n   # > [!type] optional title
    ((?:^>.*\n?)*)                     # remaining > prefixed lines
  /x

  def generate(site)
    all_docs = site.collections['notes'].docs + site.collections['pages'].docs

    all_docs.each do |doc|
      doc.content = doc.content.gsub(CALLOUT_REGEX) do
        type = Regexp.last_match(1).downcase
        custom_title = Regexp.last_match(2).strip
        body_raw = Regexp.last_match(3)

        title = custom_title.empty? ? type.capitalize : custom_title

        body = body_raw.lines.map { |line|
          line.sub(/^>\s?/, '')
        }.join

        <<~HTML
          <section class="callout callout-#{type}">
          <div class="callout-title">#{title}</div>

          #{body}
          </section>
        HTML
      end
    end
  end
end
