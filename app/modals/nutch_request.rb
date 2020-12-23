class NutchRequest < ApplicationRecord
  include StatusTrackable
  has_many :job_queues
  has_many :site_maps
  enum status: %i[pending in_progress completed failed]
end