class PageFetcher
  attr_reader :root_url, :page_registry

  def initialize(domain, page_registry)
    @root_url = "http://#{domain}"
    @page_registry = page_registry
  end

  def fetch_set(links_to_fetch)
    links_to_fetch.each do |uri|
      page = fetch_page(uri, http_get(uri).body)
      page_registry.add(page)
    end
  end

  def fetch_page(uri, html_body)
    page = Page.new(html_body)
    page_registry.uri_fetched(uri)
    page
  end

  def http_get(url_to_get)
    puts "Fetching #{@root_url}#{url_to_get}"
    faraday = Faraday.new(@root_url) do |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.adapter Faraday.default_adapter
    end

    faraday.tap { |transport| transport.headers[:user_agent] = user_agent }

    faraday.get(url_to_get)
  end

  def user_agent
    "Charlotte/#{Charlotte::Version} (https://github.com/X0nic/charlotte)"
  end
end
