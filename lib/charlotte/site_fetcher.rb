class SiteFetcher
  attr_reader :root_url, :page_registry, :levels, :current_level

  def initialize(domain, levels)
    @domain = domain
    @levels = levels
    @current_level = 0

    @page_registry = PageRegistry.new
    @root_url = "http://#{domain}"
  end

  def fetch
    fetch_set(["/"])

    while current_level < levels
      fetch_set(page_registry.links_to_fetch)
    end
    page_registry
  end

  def parallel_fetch
    # Do some parallel stuff here
    # https://github.com/lostisland/faraday/wiki/Parallel-requests
    fetch
  end

  def fetch_set(links_to_fetch)
    links_to_fetch.each do |uri|
      page = fetch_page(uri, http_get(uri).body)
      page_registry.add(page)
    end
    @current_level += 1
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

  def fetch_page(uri, html_body)
    page = Page.new(html_body)
    page_registry.uri_fetched(uri)
    page
  end

  def http_get(url_to_get)
    puts "Fetching #{@root_url}#{url_to_get}"
    Faraday.new(@root_url) { |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.adapter Faraday.default_adapter
    }.tap { |transport|
      transport.headers[:user_agent] = "Charlotte/#{Charlotte::Version} (https://github.com/X0nic/charlotte)"
    }.get(url_to_get)
  end
end
