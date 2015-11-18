class Page
  def initialize(html_body)
    @html_body = html_body
  end

  def links
    html_doc = Nokogiri::HTML(@html_body)
    get_all_internal_hrefs(html_doc)
  end

  private
  def get_all_hrefs(doc)
    links = doc.css('a')

    links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if(&:empty?)
  end

  def get_all_internal_hrefs(doc)
    get_all_hrefs(doc).reject{|link| link.match(/^http/)}
  end
end
