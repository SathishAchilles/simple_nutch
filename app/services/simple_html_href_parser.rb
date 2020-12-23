require 'nokogiri'
require 'addressable/uri'

# A simple HTML file parser. Looks up for Hyperlinks within a file
class SimpleHTMLHREFParser < ApplicationService
  DEFAULT_TAG = 'a'.freeze
  DEFAULT_TAG_ATTR_MAP = { 'a' => 'href' }.freeze

  def initialize(html, job)
    @html_nodes = Nokogiri::HTML(html)
    @job = job
    @tag = self.class::DEFAULT_TAG
    @tag_attr_map = self.class::DEFAULT_TAG_ATTR_MAP
  end

  # @return [Array[Array[String, Hash]]] Array of Array of URL string and mapping query params
  def execute
    filter_attr_values.map { |value| handle_value(value) }.compact
  end

  private

  attr_reader :html_nodes, :job, :tag, :tag_attr_map

  def filter_attr_values
    html_nodes.css(tag).map { |a| a.attributes[tag_attr_map[tag]].try(:value) }.compact
  end

  def handle_value(value)
    if url?(value)
      handle_url(value)
    else
      logger.info("possible static URL identified #{value}")
      nil
    end
  end

  def handle_url(url)
    uri = Addressable::URI.parse(url)
    url_query_param_map = [uri.query_values]
    uri.query_values = nil # to remove the existing query params
    url_query_param_map.unshift(uri.to_s)
  end

  def url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError => e
    logger.warn(e)
    false
  end
end
