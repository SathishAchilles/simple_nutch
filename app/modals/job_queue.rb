# Contains all harvested links further processing
class JobQueue < ApplicationRecord
  include StatusTrackable
  belongs_to :nutch_request
  default_scope { order(id: :asc) }
  enum status: %i[queued in_progress completed failed]
end
