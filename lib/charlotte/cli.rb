require "thor"

module Charlotte
  class CLI < Thor
    desc "get URL", "This will grab a URL"
    def get(url)
      html_doc = Nokogiri::HTML(http_get(url).body)
      puts get_all_internal_hrefs(html_doc)
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w[-v --version] => :version


    private
    def http_get(url)
      Faraday.new(url) { | connection |
        connection.use FaradayMiddleware::FollowRedirects
        connection.adapter Faraday.default_adapter
      }.get("/")
    end

    def get_all_hrefs(doc)
      links = doc.css('a')

      links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if {|href| href.empty?}
    end

    def get_all_internal_hrefs(doc)
      get_all_hrefs(doc).reject{|link| link.match(/^http/)}
    end
  end

end
