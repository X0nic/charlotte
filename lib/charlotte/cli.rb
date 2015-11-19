require "thor"

module Charlotte
  class CLI < Thor
    desc "links DOMAIN", "This will list all links found at a domain"
    def links(domain)
      page_registry = SiteFetcher.new(domain).fetch

      print "*"*10
      print " All Urls "
      print "*"*10
      print "\n"

      puts page_registry.to_s

      print "*"*10
      print " Urls to fetch "
      print "*"*10
      print "\n"

      puts page_registry.links_to_fetch

      print "*"*10
      print " Stats "
      print "*"*10
      print "\n"

      puts page_registry.stats
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w[-v --version] => :version

  end
end
