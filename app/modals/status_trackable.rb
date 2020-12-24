# Models that needs to track status can include this module
module StatusTrackable
  def track_status(raise_exception: false)
    update(status: :in_progress)
    yield
    update(status: :completed)
  rescue StandardError => exception
    update(status: :failed)
    log_exception(exception, raise_exception: raise_exception)
  end
end
