require 'uri'
# Validates URL for various schemes
class URLValidator
  class << self
    include Log
    def url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError => exception
      logger.warn(exception)
      false
    end

    def nutch_request_domain?(nutch_request_domain, current_url)
      nutch_request_domain == Addressable::URI.parse(current_url).domain
    end
  end
end
