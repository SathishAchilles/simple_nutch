module Jobs
  # Consumer Worker that consume the job and executes the given block on that data
  class Worker
    include Log
    attr_reader :job_manager

    def initialize(job_manager)
      @job_manager = job_manager
    end

    def call(&block)
      Thread.new do
        while (job = job_manager.queue.deq)
          block.call(job)
        end
      rescue ThreadError => exception
        logger.fatal(exception.backtrace)
      ensure
        job_manager.queue.close
      end
    end
  end
end
