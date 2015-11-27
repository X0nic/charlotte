require "spec_helper"

describe PageFetcher do
  let(:domain) { "duckduckgo.com" }

  before do
    file_path = "./spec/support/duckduckgo_com"

    FakeWeb.register_uri :get,
                         "http://duckduckgo.com",
                         response: IO.read(File.expand_path("#{file_path}.http"))

    FakeWeb.register_uri :get,
                         "https://duckduckgo.com",
                         response: IO.read(File.expand_path("#{file_path}.https"))

    # To grab another sample data
    # curl -is http://duckduckgo.com > spec/support/duckduckgo_com.html
  end

  context "when a single page site" do
    let(:body) { IO.read("./spec/support/duckduckgo_com.html") }

    subject(:fetcher) { PageFetcher.new(domain) }

    describe "#fetch" do
      it "fetches page body" do
        expect(fetcher.fetch_page("/")).to eq body
      end
    end
  end
end
