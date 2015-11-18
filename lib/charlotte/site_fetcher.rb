class SiteFetcher
  def initialize(domain)
    @domain = domain
    @url = "http://#{domain}"
  end

  def fetch
    html_body = http_get(@url).body
    Page.new(html_body).links
  end

  private
  def http_get(url)
    Faraday.new(url) { | connection |
      connection.use FaradayMiddleware::FollowRedirects
      connection.adapter Faraday.default_adapter
    }.get("/")
  end
end
