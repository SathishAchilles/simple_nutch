require 'addressable'
# Holds the Request Details for a run
class NutchRequest < ApplicationRecord
  include StatusTrackable
  has_many :job_queues
  has_many :site_maps
  enum status: %i[pending in_progress completed failed]

  def domain
    Addressable::URI.parse(url).domain
  end
end
