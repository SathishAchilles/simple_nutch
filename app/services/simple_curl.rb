require 'uri'
require 'open-uri'

# Simply downloads the HTML to a Tempfile
class SimpleCurl < ApplicationService
  def initialize(url)
    @url = url
  end

  # @return [Tempfile]
  def execute
    URI.parse(url).open
  rescue URI::InvalidURIError, SocketError, OpenURI::HTTPError => exception
    logger.warn(exception.backtrace)
    raise
  end

  private

  attr_reader :url
end
