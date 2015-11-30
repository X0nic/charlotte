require "spec_helper"

describe SiteFetcher do
  let(:domain) { "magical.domain" }
  let(:page_fetcher) { instance_double(PageFetcher) }
  let(:page_registry) { instance_double(PageRegistry, links_to_fetch: ["/"]) }
  let(:page) { instance_double(Page) }

  before do
    allow(PageFetcher).to receive(:new).and_return(page_fetcher)
    allow(PageRegistry).to receive(:new).and_return(page_registry)
    allow(page_registry).to receive(:add_set)
  end

  context "when a single page site" do
    context "when levels is set to 1" do
      subject(:fetcher) { SiteFetcher.new(domain, 1) }

      describe "#fetch" do
        it "fetches 1 set" do
          allow(page_registry).to receive(:uris_fetched)
          expect(page_fetcher).to receive(:fetch_set).with(["/"]).once
          fetcher.fetch
        end
        it "adds page to registry" do
          allow(page_fetcher).to receive(:fetch_set)
          allow(page_registry).to receive(:uris_fetched)
          expect(page_registry).to receive(:add_set).once
          fetcher.fetch
        end
        it "tells registry uris were fetched" do
          allow(page_fetcher).to receive(:fetch_set)
          expect(page_registry).to receive(:uris_fetched).with(["/"]).once
          fetcher.fetch
        end
      end
    end

    # context "when levels is set to 2" do
    #   subject(:fetcher) { SiteFetcher.new(domain, 2) }
    #
    #   describe "#fetch" do
    #     it "fetches 1 set" do
    #       expect(page_fetcher).to receive(:fetch_set).with(["/"]).once
    #       fetcher.fetch
    #     end
    #   end
    # end
  end
end
