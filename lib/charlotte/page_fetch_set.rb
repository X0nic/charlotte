class PageFetchSet
  attr_reader :fetch_set

  def initialize
    @fetch_set = {}
  end

  def add(uri, page)
    fetch_set[uri] = page unless fetch_set.key?(uri)
  end

  def pages
    fetch_set.values
  end

  def page_for_url(url)
    fetch_set.fetch(url)
  end

  def count
    @fetch_set.count
  end
end
