# Sitemap modal to store urls & query params
class SiteMap < ApplicationRecord
  belongs_to :nutch_request

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
