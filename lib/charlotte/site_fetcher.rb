class SiteFetcher
  attr_reader :page_registry, :levels, :current_level, :page_fetcher

  def initialize(domain, levels)
    @domain = domain
    @levels = levels
    @current_level = 0

    @page_registry = PageRegistry.new
    @page_fetcher = PageFetcher.new(domain, @page_registry)
  end

  def fetch
    while current_level < levels
      page_fetcher.fetch_set(page_registry.links_to_fetch)
      @current_level += 1
    end
    page_registry
  end

  def parallel_fetch
    # Do some parallel stuff here
    # https://github.com/lostisland/faraday/wiki/Parallel-requests
    fetch
  end

  def print_results
    print_header "All Urls"
    puts page_registry.to_s

    print_header "Urls to fetch"
    puts page_registry.links_to_fetch

    print_header "Assets"
    puts page_registry.assets.uniq

    print_header("Stats")
    puts page_registry.stats
  end

  private

  def print_header(header)
    print "*" * 10
    print " #{header} "
    print "*" * 10
    print "\n"
  end
end
