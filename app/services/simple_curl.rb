require 'uri'

# Simply downloads the HTML to a Tempfile
class SimpleCurl < ApplicationService
  def initialize(url)
    @url = url
  end

  # @return [Tempfile]
  def execute
    URI.parse(url).open
  rescue SocketError => e
    logger.warn(e.backtrace)
  end

  private

  attr_reader :url
end
