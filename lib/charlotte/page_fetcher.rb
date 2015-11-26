class PageFetcher
  attr_reader :root_url

  def initialize(domain)
    @root_url = "http://#{domain}"
  end

  def fetch_set(links_to_fetch)
    page_fetch_set = PageFetchSet.new

    links_to_fetch.each do |uri|
      page = fetch_page(uri)
      page_fetch_set.add(uri, page)
    end

    page_fetch_set
  end

  def fetch_page(uri)
    html_body = http_get(uri).body
    page = Page.new(html_body)
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
