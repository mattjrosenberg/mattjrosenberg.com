# frozen_string_literal: true
require 'nokogiri'

# Add target="_blank" to external links (non-internal, non-footnote)
# when open_external_links_in_new_tab is enabled in _config.yml

def convert_external_links(doc)
  return unless doc.site.config["open_external_links_in_new_tab"]

  parsed = Nokogiri::HTML(doc.content)
  parsed.css("a:not(.internal-link):not(.footnote-backref)").each do |link|
    link.set_attribute('target', 'blank')
  end
  doc.content = parsed.to_html
end

Jekyll::Hooks.register [:notes], :post_convert do |doc|
  convert_external_links(doc)
end

Jekyll::Hooks.register [:pages], :post_convert do |doc|
  next unless doc.path.start_with?('_pages/')
  convert_external_links(doc)
end
