# Creates JobQueue only for unique URLs and increments counter for duplicate ref
class JobQueueService < ApplicationService
  def initialize(url, nutch_request_id, depth)
    @url = url
    @nutch_request_id = nutch_request_id
    @depth = depth
    @job_queue = JobQueue.find_by(nutch_request_id: nutch_request_id, url: url)
  end

  def execute
    if URLValidator.url?(url)
      create_or_increment_job
    else
      logger.info("Skipping possible static URL #{url}")
      nil
    end
  end

  private

  attr_reader :url, :nutch_request_id, :job_queue, :depth

  def create_or_increment_job
    if job_queue
      job_queue&.increment!(:duplicate_reference)
      logger.info("Incrementing duplicate reference for URL: #{url}")
    else
      JobQueue.create(nutch_request_id: nutch_request_id, url: url, depth: depth)
      logger.info("Queuing URL: #{url}")
    end
  end
end
