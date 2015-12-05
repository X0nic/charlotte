class PageFetchSet
  attr_reader :fetch_set

  def initialize(responses)
    @responses = responses
    @fetch_set = {}
    responses.each do |url, response|
      add(url, response)
    end
  end

  def pages
    fetch_set.values
  end

  def page_for_url(url)
    fetch_set.fetch(url)
  end

  def count
    fetch_set.count
  end

  private

  attr_reader :responses

  def add(uri, response)
    html_body = response.body.force_encoding("UTF-8")
    page = Page.new(uri, html_body)
    @fetch_set[uri] = page
    @fetch_set
  end
end
