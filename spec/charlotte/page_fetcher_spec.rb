require "spec_helper"

def mock_page(url)

  FakeWeb.register_uri :get,
    "http://duckduckgo.com#{url}",
    response: IO.read(File.expand_path("#{file_path}#{url.gsub('/','-')}.http"))

  FakeWeb.register_uri :get,
    "https://duckduckgo.com#{url}",
    response: IO.read(File.expand_path("#{file_path}#{url.gsub('/','-')}.https"))

    # response = IO.read(File.expand_path("#{file_path}#{url.gsub('/','-')}.https"))
    # IO.write(File.expand_path("#{file_path}#{url.gsub('/','-')}.html"), response)

    # To grab another sample data
    # curl -is http://duckduckgo.com > spec/support/duckduckgo_com.html
end

def load_page(url)
  IO.read("#{file_path}#{url.gsub('/','-')}.html")
end

describe PageFetcher do
  let(:file_path) { "./spec/support/#{domain.gsub('.', '_')}" }
  let(:domain) { "duckduckgo.com" }
  let(:index_body) { load_page("/") }
  let(:about_body) { load_page("/about") }
  let(:spread_body) { load_page("/spread") }
  let(:tour_body) { load_page("/tour") }

  before do
    mock_page("/")
    mock_page("/about")
    mock_page("/spread")
    mock_page("/tour")
  end

  context "when fetching a single page" do
    subject(:fetcher) { PageFetcher.new(domain) }

    describe "#fetch" do
      it "fetches page body" do
        expect(fetcher.fetch_page("/")).to eq index_body
      end
    end
  end

  context "when fetching a muliple pages" do
    subject(:fetcher) { PageFetcher.new(domain) }

    describe "#fetch_set" do
      subject(:fetch_set) { fetcher.fetch_set(["/about", "/spread", "/tour"]) }
      it "fetches all pages" do
        expect(subject.count).to eq 3
      end
      it "fetches /about" do
        expect(subject.page_for_url("/about")).to eq about_body
      end
      it "fetches /spread" do
        expect(subject.page_for_url("/spread")).to eq spread_body
      end
      it "fetches /tour" do
        expect(subject.page_for_url("/tour")).to eq tour_body
      end
    end
  end
end
