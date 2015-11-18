class SiteFetcher
  def initialize(domain)
    @domain = domain
    @url = "http://#{domain}"
  end

  def links
    html_doc = Nokogiri::HTML(http_get(@url).body)
    puts get_all_internal_hrefs(html_doc)
  end

  private
  def http_get(url)
    Faraday.new(url) { | connection |
      connection.use FaradayMiddleware::FollowRedirects
      connection.adapter Faraday.default_adapter
    }.get("/")
  end

  def get_all_hrefs(doc)
    links = doc.css('a')

    links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if(&:empty?)
  end

  def get_all_internal_hrefs(doc)
    get_all_hrefs(doc).reject{|link| link.match(/^http/)}
  end
end

