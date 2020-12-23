# recursively crawls the URL links
class RecursiveCrawler < ApplicationService
  ROOT_DEPTH = 0

  def initialize(crawl_root_url)
    @crawl_root_url = crawl_root_url
    @nutch_request = NutchRequest.create(url: crawl_root_url)
  end

  def execute
    nutch_request.track_status do
      JobQueue.create(nutch_request: nutch_request, url: crawl_root_url, depth: ROOT_DEPTH)
      execute_queue { |job| SiteMapCatalogBuilder.perform(job.id) }
    end
  end

  private

  attr_reader :crawl_root_url, :nutch_request

  def execute_queue(batch_size: 5)
    loop do
      job_queue = JobQueue.queued.where(nutch_request: nutch_request).reload
      break unless job_queue.exists?

      job_queue.in_batches(of: batch_size).each_record do |job|
        yield job
      end
    end
  end
end
