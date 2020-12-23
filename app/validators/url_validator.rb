require 'uri'
# Validates URL for various schemes
class URLValidator
  class << self
    def url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError => exception
      logger.warn(exception)
      false
    end
  end
end
