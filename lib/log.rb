require 'logger'
# Initializes logger instance to share across the app
module Log
  def logger
    @logger ||= ApplicationRecord.logger
  end
end
