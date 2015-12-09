require "thor"

module Charlotte
  class CLI < Thor
    desc "fetch DOMAIN", "This will list all links found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def fetch(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      site_fetcher.fetch
      site_fetcher.print_results
    end

    desc "visualize_pages DOMAIN", "This will visualize all pages found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def visualize_pages(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      site_fetcher.fetch
      site_fetcher.graph_results
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w(-v --version) => :version
  end
end
