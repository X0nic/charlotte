$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "charlotte"

require "fakeweb"

FakeWeb.allow_net_connect = false

def spec_path(domain)
  "./spec/support/#{domain.tr('.', '_')}"
end

def mock_page(domain, url)
  FakeWeb.register_uri :get,
                       "http://duckduckgo.com#{url}",
                       response: IO.read("#{spec_path(domain)}#{url.tr('/', '-')}.http")

  FakeWeb.register_uri :get,
                       "https://duckduckgo.com#{url}",
                       response: IO.read("#{spec_path(domain)}#{url.tr('/', '-')}.https")

  # response = IO.read(File.expand_path("#{file_path}#{url.gsub('/','-')}.https"))
  # IO.write(File.expand_path("#{file_path}#{url.gsub('/','-')}.html"), response)

  # To grab another sample data
  # curl -is http://duckduckgo.com > spec/support/duckduckgo_com.html
end

def load_page(domain, url)
  IO.read("#{spec_path(domain)}#{url.tr('/', '-')}.html")
end
