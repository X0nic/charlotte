class AssetVisualizer
  def initialize(page_registry)
    @page_registry = page_registry
  end

  def output
    # Create a new graph
    g = GraphViz.new(:G, type: :digraph)

    print_header("nodes")
    nodes = {}
    page_registry.links_fetched.each do |url|
      puts url unless nodes.key?(url)
      nodes[url] = g.add_nodes(url) unless nodes.key?(url)
    end
    page_registry.assets.each do |url|
      puts url unless nodes.key?(url)
      nodes[url] = g.add_nodes(url) unless nodes.key?(url)
    end

    print_header("edges")
    nodes.keys.each do |node_url|
      page = page_registry.page_catalog[node_url]
      next unless page
      page.assets.each do |url|
        puts "#{node_url} - #{url}" if nodes.key?(url)
        g.add_edges(nodes[node_url], nodes[url]) if nodes.key?(url)
      end
    end

    # page_registry.links.each do |link, _status|
    #   g.add_nodes(link)
    # end

    # Generate output image
    file_name = "assets.png"
    g.output(png: file_name)
    puts "File saved to: #{file_name}"
  end

  private

  attr_reader :page_registry

  def print_header(header)
    print "*" * 10
    print " #{header} "
    print "*" * 10
    print "\n"
  end
end
