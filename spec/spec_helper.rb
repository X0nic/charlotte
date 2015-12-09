$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "charlotte"

require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

def spec_path(domain)
  "./spec/support/#{domain.tr('.', '_')}"
end

def load_page(domain, url)
  IO.read("#{spec_path(domain)}#{url.tr('/', '-')}.html").force_encoding("UTF-8")
end

def write_page(domain, url, html)
  IO.write("#{spec_path(domain)}#{url.gsub('/','-')}.html", html)
end
