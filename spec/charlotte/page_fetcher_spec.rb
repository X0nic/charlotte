require "spec_helper"
describe PageFetcher do
  let(:domain) { "duckduckgo.com" }
  let(:index_body) { load_page(domain, "/") }
  let(:about_body) { load_page(domain, "/about") }
  let(:spread_body) { load_page(domain, "/spread") }
  let(:tour_body) { load_page(domain, "/tour") }

  context "when fetching a single page", :vcr do
    subject(:fetcher) { PageFetcher.new(domain) }

    describe "#fetch_set" do
      subject(:fetch_set) { fetcher.fetch_set("/") }

      it "fetches 1 page" do
        expect(fetch_set.count).to eq 1
      end
      it "fetches page body" do
        expect(fetch_set.page_for_url("/").html_body).to eq index_body
      end
    end
  end

  context "when fetching a muliple pages", :vcr do
    subject(:fetcher) { PageFetcher.new(domain) }

    describe "#fetch_set" do
      subject(:fetch_set) { fetcher.fetch_set(["/about", "/spread", "/tour"]) }
      it "fetches all pages" do
        expect(subject.count).to eq 3
      end
      it "fetches /about" do
        expect(subject.page_for_url("/about").html_body).to eq about_body
      end
      it "fetches /spread" do
        expect(subject.page_for_url("/spread").html_body).to eq spread_body
      end
      it "fetches /tour" do
        expect(subject.page_for_url("/tour").html_body).to eq tour_body
      end
    end
  end
end
