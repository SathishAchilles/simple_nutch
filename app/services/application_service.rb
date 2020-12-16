# interface for Service classes
class ApplicationService
  include Log
  class << self
    def call(*args, &block)
      new(*args, &block).execute
    end
  end

  def execute
    raise NotImplementedError
  end
end
