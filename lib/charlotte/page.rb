class Page
  def initialize(html_body)
    @html_doc = Nokogiri::HTML(html_body)
  end

  def links
    get_all_internal_hrefs(html_doc)
  end

  def assets
    images + stylesheets + scripts
  end

  private

  attr_reader :html_doc

  def images
    images = html_doc.css('img')
    images.map { |link| link.attribute('src').to_s }.uniq.sort.delete_if(&:empty?)
  end

  def stylesheets
    styles = html_doc.css('link')
    styles.map { |link| link.attribute('href').to_s }.uniq.sort.delete_if(&:empty?)
  end

  def scripts
    images = html_doc.css('scripts')
    images.map { |link| link.attribute('src').to_s }.uniq.sort.delete_if(&:empty?)
  end

  def get_all_hrefs(doc)
    links = doc.css('a')

    links.map { |link| link.attribute('href').to_s }.uniq.sort.delete_if(&:empty?)
  end

  def get_all_internal_hrefs(doc)
    get_all_hrefs(doc).reject { |link| link.match(/^http/) }
  end
end
