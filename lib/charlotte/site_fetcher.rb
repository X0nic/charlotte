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

  def graph_results
    require "graphviz"

    # Create a new graph
    g = GraphViz.new(:G, type: :digraph)

    print_header("nodes")
    nodes = {}
    page_registry.links.keys.uniq.each do |url|
      puts url unless nodes.key?(url)
      nodes[url] = g.add_nodes(url) unless nodes.key?(url)
    end

    print_header("edges")
    nodes.keys.each do |node_url|
      page = page_registry.page_catalog[node_url]
      next unless page
      page.links.each do |url|
        puts "#{node_url} - #{url}" if nodes.key?(url)
        g.add_edges(nodes[node_url], nodes[url]) if nodes.key?(url)
      end
    end

    page_registry.links.each do |link, _status|
      g.add_nodes(link)
    end

    # Generate output image
    file_name = "pages.png"
    g.output(png: file_name)
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
