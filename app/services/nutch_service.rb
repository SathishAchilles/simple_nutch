# Trigger the Nutch Service, delegate tasks to Job Manager
class NutchService < ApplicationService
  ROOT_DEPTH = 0

  def initialize(root_url)
    validate_url(root_url)
    @nutch_request = NutchRequest.create(url: root_url)
    @job_manager = Jobs::Manager.new
    JobQueueService.call(root_url, nutch_request.id, ROOT_DEPTH)
  end

  def execute
    nutch_request.track_status(raise_exception: true) do
      job_queue = JobQueue.queued.where(nutch_request: nutch_request)
      job_manager.process(job_queue, worker_class: SiteMapCatalogBuilder)
    end
  end

  private

  attr_reader :nutch_request, :job_manager

  def validate_url(url)
    raise StandardError, "invalid URL: #{url} " unless URLValidator.url?(url)
  end
end
