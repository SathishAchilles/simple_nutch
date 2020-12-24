require 'nokogiri'
require 'addressable/uri'

# A simple HTML file parser. Looks up for Hyperlinks within a file
class SimpleHTMLHREFParser < ApplicationService
  DEFAULT_TAG = 'a'.freeze
  DEFAULT_TAG_ATTR_MAP = { 'a' => 'href' }.freeze

  def initialize(html)
    @html_nodes = Nokogiri::HTML(html)
    @tag = self.class::DEFAULT_TAG
    @tag_attr_map = self.class::DEFAULT_TAG_ATTR_MAP
  end

  # @return [Array[Array[String, Hash]]] Array of Array of URL string and mapping query params
  def execute
    filter_href_values
  end

  private

  attr_reader :html_nodes, :tag, :tag_attr_map

  def filter_href_values
    html_nodes.css(tag).map { |node| node.attributes[tag_attr_map[tag]].try(:value) }.compact
  end
end
