class PageVisualizer
  def initialize(page_registry)
    @page_registry = page_registry
  end

  def output
    g = GraphViz.new(:G, type: :digraph, rankdir: "LR")

    nodes = add_graph_nodes(g)

    add_graph_edges(g, nodes)

    generate_output_image(g)
  end

  private

  def add_graph_nodes(graph)
    print_header("nodes")
    nodes = {}
    page_registry.links.keys.uniq.each do |url|
      puts url unless nodes.key?(url)
      nodes[url] = graph.add_nodes(url) unless nodes.key?(url)
    end

    nodes
  end

  def add_graph_edges(graph, nodes)
    print_header("edges")
    nodes.keys.each do |node_url|
      page = page_registry.page_catalog[node_url]
      next unless page
      page.links.each do |url|
        puts "#{node_url} - #{url}" if nodes.key?(url)
        graph.add_edges(nodes[node_url], nodes[url]) if nodes.key?(url)
      end
    end
  end

  def generate_output_image(graph)
    file_name = "assets.png"
    graph.output(png: file_name)
    puts "File saved to: #{file_name}"
    file_name
  end

  attr_reader :page_registry

  def print_header(header)
    print "*" * 10
    print " #{header} "
    print "*" * 10
    print "\n"
  end
end
