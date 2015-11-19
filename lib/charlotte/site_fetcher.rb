class SiteFetcher
  attr :url, :page_registry

  def initialize(domain)
    @domain = domain

    @page_registry = PageRegistry.new
    @url = "http://#{domain}"
  end

  def fetch
    html_body = http_get.body
    links = Page.new(html_body).links
    page_registry.add_links(links)
    page_registry
  end

  private
  def http_get
    Faraday.new(url) { | connection |
      connection.use FaradayMiddleware::FollowRedirects
      connection.adapter Faraday.default_adapter
    }.get("/")
  end
end
