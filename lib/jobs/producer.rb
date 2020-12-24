module Jobs
  # Producer to fill the consumer Q periodically
  # Actively polls the DB for the given custom job_queue scope for queued entries
  # and pushes them JobManager Q
  class Producer
    include Log
    WAIT_TIME = 5
    BATCH_SIZE = 5

    attr_reader :job_queue, :job_manager, :wait_time, :batch_size

    def initialize(job_queue, job_manager, batch_size: self.class::BATCH_SIZE, wait_time: self.class::WAIT_TIME)
      @job_queue = job_queue
      @job_manager = job_manager
      @wait_time = wait_time
      @batch_size = batch_size
      @tries = 0
    end

    def call
      Thread.new do
        loop do
          break if job_queue_empty?

          fill_queue
        end
      end.join
    end

    private

    def fill_queue
      job_queue.in_batches(of: batch_size) do |jobs|
        job_manager.queue = jobs
      end
    end

    def job_queue_empty?
      return true if !job_queue.reload.exists? && @tries > 2

      # if job_queue doesn't exist try 3 times for every wait time
      @tries += 1
      sleep wait_time
      false
    end
  end
end
