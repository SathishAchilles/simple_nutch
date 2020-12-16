require 'logger'
# Initializes logger instance to share across the app
module Log
  def logger
    @logger ||= Logger.new($stdout)
  end
end
