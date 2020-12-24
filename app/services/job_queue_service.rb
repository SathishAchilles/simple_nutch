# Creates JobQueue only for unique URLs and increments counter for duplicate ref
class JobQueueService < ApplicationService
  INCLUDE_NON_MATCHING_DOMAINS = false
  def initialize(url, nutch_request_id, depth)
    @url = url
    @nutch_request = NutchRequest.find(nutch_request_id)
    @depth = depth
    @job_queue = JobQueue.find_by(nutch_request: nutch_request, url: url)
  end

  def execute
    if URLValidator.url?(url)
      create_or_increment_job_queue
    else
      logger.info("Skipping possible static URL #{url}")
      nil
    end
  end

  private

  attr_reader :url, :nutch_request, :job_queue, :depth

  def create_or_increment_job_queue
    if job_queue
      increment_job_queue
    else
      create_job_queue
    end
  end

  def create_job_queue
    if eligible_to_harvest?(url)
      JobQueue.create(nutch_request: nutch_request, url: url, depth: depth)
      logger.info("Queuing URL: #{url}")
    else
      logger.info("Skipping Non Eligible URL: #{url}")
    end
  end

  def increment_job_queue
    job_queue.increment!(:duplicate_reference)
    logger.info("Incrementing duplicate reference for URL: #{url}")
  end

  def eligible_to_harvest?(url)
    return true if self.class::INCLUDE_NON_MATCHING_DOMAINS

    URLValidator.nutch_request_domain?(nutch_request.domain, url)
  end
end
