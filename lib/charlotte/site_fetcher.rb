class SiteFetcher
  attr_reader :page_registry, :levels, :current_level, :page_fetcher

  def initialize(domain, levels)
    @domain = domain
    @levels = levels
    @current_level = 0

    @page_registry = PageRegistry.new
    @page_fetcher = PageFetcher.new(domain)
  end

  def fetch
    while current_level < levels
      uris = page_registry.links_to_fetch
      fetch_set = page_fetcher.fetch_set(uris)
      page_registry.uris_fetched(uris)
      page_registry.add_set(fetch_set)
      @current_level += 1
    end
    page_registry
  end

  def parallel_fetch
    # Do some parallel stuff here
    # https://github.com/lostisland/faraday/wiki/Parallel-requests
    fetch
  end

  def print_results
    print_header "All Urls"
    puts page_registry.to_s

    print_header "Urls to fetch"
    puts page_registry.links_to_fetch

    print_header "Assets"
    puts page_registry.assets.uniq

    print_header("Stats")
    puts page_registry.stats
  end

  def graph_results
    require 'graphviz'

    # Create a new graph
    g = GraphViz.new( :G, :type => :digraph )

    # Create two nodes
    # hello = g.add_nodes( "Hello" )
    # world = g.add_nodes( "World" )

    # Create an edge between the two nodes
    # g.add_edges( hello, world )

    page_registry.links.each do |link, status|
      g.add_nodes(link)
    end

    # Generate output image
    file_name = "pages.png"
    g.output( :png => file_name)
    puts "File saved to: #{file_name}"
  end

  private

  def print_header(header)
    print "*" * 10
    print " #{header} "
    print "*" * 10
    print "\n"
  end
end
