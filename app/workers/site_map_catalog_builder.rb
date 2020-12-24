# Catalog builder Worker to perform SiteMap functions
class SiteMapCatalogBuilder
  include Log
  class << self
    def perform(job_id)
      new.perform(job_id)
    end
  end

  def perform(job_id)
    @job = JobQueue.find_by(id: job_id)
    @site_map = SiteMap.find_by_request_id_and_raw_url(job.nutch_request_id, job.url)
    create_or_increment_site_maps
    harvest_hyperlinks_from_current_url
  end

  private

  attr_reader :job, :site_map, :duplicates

  def create_or_increment_site_maps
    duplicates = job.duplicate_reference.zero? ? 1 : job.duplicate_reference
    if site_map
      site_map.increment!(:reference_count, duplicates)
    else
      SiteMap.create(nutch_request: job.nutch_request, url: job.url, reference_count: duplicates)
    end
  end

  def harvest_hyperlinks_from_current_url
    job.track_status do
      links = SimpleHTMLHREFParser.call(SimpleCurl.call(job.url))
      return unless links

      links.each { |link| JobQueueService.call(link, job.nutch_request_id, job.depth + 1) }
    end
  end
end
