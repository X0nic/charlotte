class ResultPrinter
  def initialize(page_registry)
    @page_registry = page_registry
  end

  def output
    print_header "All Urls"
    puts page_registry.to_s

    print_header "Urls to fetch"
    puts page_registry.links_to_fetch

    print_header "Assets"
    puts page_registry.assets.uniq

    print_header("Stats")
    puts page_registry.stats
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
