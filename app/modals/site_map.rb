# Sitemap modal to store urls & query params
class SiteMap < ApplicationRecord
  belongs_to :nutch_request
  class << self
    def find_by_request_id_and_raw_url(request_id, url)
      uri = Addressable::URI.parse(url)
      uri.query_values = nil
      find_by(nutch_request_id: request_id, url: uri.to_s)
    end
  end

  before_save :shovel_query_params_from_url

  def query_params=(query_params)
    return unless query_params
    raise TypeError, 'Expected String' unless query_params.is_a?(String)

    self[:query_params] = if self[:query_params]
                            self[:query_params] = "#{self[:query_params]},#{query_params}".split(',').uniq
                          else
                            query_params
                          end
    super
  end

  private

  def shovel_query_params_from_url
    uri = Addressable::URI.parse(url)
    query_params = uri.query_values
    if query_params
      self.query_params = query_params.keys.join(',')
      uri.query_values = nil
    end
    self.url = uri.to_s
  end
end
