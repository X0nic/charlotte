require "thor"

module Charlotte
  class CLI < Thor
    desc "links DOMAIN", "This will list all links found at a domain"
    def links(domain)
      site_fetcher = SiteFetcher.new(domain)

      site_fetcher.fetch
      site_fetcher.print_results
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w[-v --version] => :version

  end
end
