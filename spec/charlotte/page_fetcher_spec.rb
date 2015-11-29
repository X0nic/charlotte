require "spec_helper"
describe PageFetcher do
  let(:domain) { "duckduckgo.com" }
  let(:index_body) { load_page(domain, "/") }
  let(:about_body) { load_page(domain, "/about") }
  let(:spread_body) { load_page(domain, "/spread") }
  let(:tour_body) { load_page(domain, "/tour") }

  before do
    mock_page(domain, "/")
    mock_page(domain, "/about")
    mock_page(domain, "/spread")
    mock_page(domain, "/tour")
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
