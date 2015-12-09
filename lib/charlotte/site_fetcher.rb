class SiteFetcher
  attr_reader :levels, :domain

  def initialize(domain, levels)
    @domain = domain
    @levels = levels
  end

  def fetch
    current_level = 0
    page_registry = PageRegistry.new
    page_fetcher = PageFetcher.new(domain)

    while current_level < levels
      uris = page_registry.links_to_fetch
      fetch_set = page_fetcher.fetch_set(uris)
      page_registry.uris_fetched(uris)
      page_registry.add_set(fetch_set)
      current_level += 1
    end
    page_registry
  end
end
