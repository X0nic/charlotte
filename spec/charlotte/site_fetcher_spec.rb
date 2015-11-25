require "spec_helper"

describe SiteFetcher do
  let(:domain) { "magical.domain" }
  let(:page_fetcher) { instance_double(PageFetcher) }

  before do
    allow(PageFetcher).to receive(:new).and_return(page_fetcher)
  end

  context "when a single page site" do
    context "when levels is set to 1" do
      subject(:fetcher) { SiteFetcher.new(domain, 1) }

      describe "#fetch" do
        it "fetches 1 set" do
          expect(page_fetcher).to receive(:fetch_set).with(["/"]).once
          fetcher.fetch
        end
      end
    end
  end
end
