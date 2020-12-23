# Parent Class for all AR Modals
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def log_exception(exception, raise_exception: false)
    logger.fatal(exception.backtrace)
    raise_exception && raise
  end
end
