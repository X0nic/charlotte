require "thor"

module Charlotte
  class CLI < Thor
    desc "get URL", "This will grab a URL"
    def get(url)
      puts http_get(url).body
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
  end

end
