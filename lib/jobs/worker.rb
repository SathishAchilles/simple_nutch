module Jobs
  # Consumer Worker that consume the job and executes the given block on that data
  class Worker
    include Log
    attr_reader :job_manager, :worker_class

    def initialize(job_manager, worker_class)
      @job_manager = job_manager
      @worker_class = worker_class
    end

    def call(&block)
      Thread.new do
        while (job = job_manager.queue.deq)
          worker_class.perform(job.id)
          block.call(job) if block_given?
        end
      rescue ThreadError => exception
        logger.fatal(exception.backtrace)
      ensure
        job_manager.queue.close
      end
    end
  end
end
