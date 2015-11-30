require "thor"

module Charlotte
  class CLI < Thor
    desc "links DOMAIN", "This will list all links found at a domain"
    method_option :levels, type: :numeric, default: 99, aliases: "-l"
    def links(domain)
      site_fetcher = SiteFetcher.new(domain, options["levels"])

      site_fetcher.fetch
      site_fetcher.print_results
      site_fetcher.graph_results
    end

    desc "visualize", "Will display visualization of website"
    def visualize
      require 'graphviz'

      # Create a new graph
      g = GraphViz.new( :G, :type => :digraph )

      # Create two nodes
      hello = g.add_nodes( "Hello" )
      world = g.add_nodes( "World" )

      # Create an edge between the two nodes
      g.add_edges( hello, world )

      # Generate output image
      file_name = "hello_world.png"
      g.output( :png => file_name)
      puts "File saved to: #{file_name}"
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w(-v --version) => :version
  end
end
