module Jobs
  # Kick starts, Manages the Q for producer and consumer
  # Implements a Producer:Consumer Pattern
  class Manager
    include Log
    MAX_Q_SIZE = 20
    attr_reader :queue, :workers, :pool_size

    def initialize(pool_size = 5)
      @queue = SizedQueue.new(self.class::MAX_Q_SIZE)
      @pool_size = pool_size
    end

    # @param elements [Array[JobQueue], JobQueue] adds JobQueues to a thread safe Queue
    def queue=(elements)
      return unless elements

      @queue = SizedQueue.new(self.class::MAX_Q_SIZE) if @queue.closed?

      @queue.push(elements) unless elements.respond_to?(:each)

      elements.each do |element|
        @queue.push(element)
      end
    end

    # @param job_queue [ActiveRecord::Relation, ActiveRecord::Associations::CollectionProxy, JobQueue]
    #   JobQueue and JobQueue AR collection object with custom scopes that responds to AR .reload method
    # @param worker_class [Object] Any object that reponds to perform method and accepts job args
    # @param [&block] the block that needs to be executed on the given job queue
    # Process the job_queue with the give block
    def process(job_queue, worker_class: nil, &block)
      create_workers_for(worker_class, &block)
      activate_producer_for(job_queue)
      workers.map(&:join)
    end

    private

    def create_workers_for(worker_class, &block)
      @workers = (1..pool_size).map do
        Worker.new(self, worker_class).call(&block)
      end
    end

    def activate_producer_for(job_queue)
      Producer.new(job_queue, self, batch_size: pool_size).call
    end
  end
end
