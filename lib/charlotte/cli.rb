require "thor"
require "mkmf"

module Charlotte
  class CLI < Thor
    desc "fetch DOMAIN", "This will list all links found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def fetch(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      page_registry = site_fetcher.fetch
      ResultPrinter.new(page_registry).output
    end

    desc "visualize_pages DOMAIN", "This will visualize all pages found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def visualize_pages(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      page_registry = site_fetcher.fetch
      file_name = PageVisualizer.new(page_registry).output
      open file_name
    end

    desc "visualize_assets DOMAIN", "This will visualize all page assets found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def visualize_assets(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      page_registry = site_fetcher.fetch
      file_name = AssetVisualizer.new(page_registry).output
      open file_name
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w(-v --version) => :version

    private

    def open(file_name)
      return system "open #{file_name}" if find_executable "open"
      puts "Sorry, can only open file on OS X"
    end
  end
end
