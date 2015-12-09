require "faraday"
require "faraday_middleware"
require "nokogiri"
require "typhoeus"
require "typhoeus/adapters/faraday"

require "charlotte/page"
require "charlotte/page_fetch_set"
require "charlotte/page_fetcher"
require "charlotte/page_registry"
require "charlotte/site_fetcher"
require "charlotte/version"

module Charlotte
  def self.logger
    @@logger ||= begin
                   logger = Logger.new(STDERR)
                   logger.level = Logger::WARN
                   # logger.formatter = LogFormatter.new
                   logger
                 end
  end
end
