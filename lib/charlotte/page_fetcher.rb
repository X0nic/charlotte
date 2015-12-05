class PageFetcher
  attr_reader :root_url

  def initialize(domain)
    @root_url = "http://#{domain}"
  end

  def fetch_set(links_to_fetch)
    # page_fetch_set = PageFetchSet.new

    # links_to_fetch.each do |uri|
    #   page = fetch_page(uri)
    #   page_fetch_set.add(uri, page)
    # end
    responses = http_get(links_to_fetch)

    PageFetchSet.new(responses)
  end
  #
  # def fetch_page(uri)
  #   html_body = http_get(uri).body.force_encoding("UTF-8")
  #   Page.new(uri, html_body)
  #   # IO.write(File.expand_path("./spec/support/duckduckgo_com#{uri.gsub('/','-')}.html"), body)
  #   # body
  # end

  private

  def http_get(urls_to_get)
    responses = {}

    connection.in_parallel do
      Array(urls_to_get).each do |url_to_get|
        puts "Fetching #{@root_url}#{url_to_get}"
        responses[url_to_get] = connection.get(url_to_get)
      end
    end

    responses

    # begin
    # rescue ex
    #   require 'pry' ; binding.pry
    # end
  end

  def connection
    @connection ||=
      begin
        faraday = Faraday.new(@root_url) do |connection|
          connection.use FaradayMiddleware::FollowRedirects, limit: 5
          # connection.adapter Faraday.default_adapter
          connection.adapter :typhoeus
        end

        faraday.tap { |transport| transport.headers[:user_agent] = user_agent }
      end
  end

  def user_agent
    "Charlotte/#{Charlotte::Version} (https://github.com/X0nic/charlotte)"
  end
end
