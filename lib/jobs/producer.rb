module Jobs
  # Producer to fill the consumer Q periodically
  # Actively polls the DB for the given custom job_queue scope for queued entries
  # and pushes them JobManager Q
  class Producer
    include Log
    WAIT_TIME = 5
    BATCH_SIZE = 5
    MAX_RETRY_TRAILS = 3

    attr_reader :job_queue, :job_manager, :batch_size, :retries

    def initialize(job_queue, job_manager, batch_size: self.class::BATCH_SIZE)
      @job_queue = job_queue
      @job_manager = job_manager
      @batch_size = batch_size
      @retries = 0
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
      return true if !job_queue.reload.exists? && retries > self.class::MAX_RETRY_TRAILS

      # if job_queue doesn't exist, try MAX_RETRY_TRAILS times for every wait time
      unless job_queue.exists?
        @retries += 1
        sleep self.class::WAIT_TIME
      end
      false
    end
  end
end
