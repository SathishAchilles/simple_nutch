# Catalog builder Worker to perform SiteMap functions
class SiteMapCatalogBuilder
  class << self
    def perform(job_id)
      new.perform(job_id)
    end
  end

  def perform(job_id)
    job = JobQueue.find_by(id: job_id)
    site_map = SiteMap.find_by_request_id_and_raw_url(job.nutch_request_id, job.url)
    duplicates = job.duplicate_reference.zero? ? 1 : job.duplicate_reference
    if site_map
      site_map.increment!(:reference_count, duplicates)
    else
      SiteMap.create(nutch_request_id: job.nutch_request_id, url: job.url, reference_count: duplicates)
    end

    job.track_status do
      SimpleHTMLHREFParser.call(SimpleCurl.call(job.url), job)
    end
  end
end
