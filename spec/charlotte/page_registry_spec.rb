require "spec_helper"

describe PageRegistry do
  subject(:registry) { PageRegistry.new }

  let(:links) { ["/a", "/"] }
  let(:assets) { ["/test2.png", "favicon.ico"] }
  let(:page) { instance_double(Page, links: links, assets: assets) }

  let(:new_assets) { ["/test.png", "favicon.ico"] }
  let(:new_links) { ["/a", "/b"] }
  let(:new_page) { instance_double(Page, links: new_links, assets: new_assets) }

  let(:page_set) { instance_double(PageFetchSet, pages: [page, new_page]) }

  context "with an empty registry" do
    describe "#initialize" do
      it "initializes with the root url" do
        expect(registry.links).to match "/" => PageRegistry::NOT_FETCHED
      end
    end

    describe '#add' do
      before { registry.add(page) }

      it "it adds 2 links" do
        expect(registry.links.count).to eq 2
      end
      it "adds page links" do
        expect(registry.links).to match "/a" => PageRegistry::NOT_FETCHED,
                                        "/" => PageRegistry::NOT_FETCHED
      end
      it "adds page assets" do
        expect(registry.assets).to match assets
      end
    end

    describe "#add_set" do
      before { registry.add_set(page_set) }

      it "it adds 3 links" do
        expect(registry.links.count).to eq 3
      end
      it "adds page links" do
        expect(registry.links).to match "/a" => PageRegistry::NOT_FETCHED,
                                        "/" => PageRegistry::NOT_FETCHED,
                                        "/b" => PageRegistry::NOT_FETCHED
      end
      it "adds page assets" do
        expect(registry.assets).to match assets + ["/test.png"]
      end
    end

    describe "#stats" do
      subject(:stats) { registry.stats }

      it "has zeroed stats" do
        is_expected.to match total_links: 1,
                             total_assets: 0,
                             unfetched_links: 1
      end
    end
  end

  context "with a populated registry" do
    subject(:populated_registry) do
      registry.add(page)
      registry
    end

    describe '#add' do
      before do
        populated_registry.add(new_page)
        populated_registry.uri_fetched("/a")
      end

      it "it adds 1 new link" do
        expect(populated_registry.links.count).to eq 3
      end
      it "does not overwrite existing links" do
        expect(populated_registry.links).to match "/a" => PageRegistry::FETCHED,
                                                  "/b" => PageRegistry::NOT_FETCHED,
                                                  "/" => PageRegistry::NOT_FETCHED
      end
      it "does not duplicate extra asset" do
        expect(populated_registry.assets).to match assets + ["/test.png"]
      end
    end

    describe "#uri_fetched" do
      before do
        populated_registry.add(new_page)
      end

      it "marks already added uris as fetched" do
        populated_registry.uri_fetched("/b")
        expect(populated_registry.links).to include "/b" => PageRegistry::FETCHED
      end

      it "errors when uri has not already been added" do
        expect {
          populated_registry.uri_fetched("/middle_of_nowhere")
        }.to raise_error(PageRegistry::NotRegisteredError, "Don't know about this url, can not mark it as fetched.")
      end
    end

    describe "#stats" do
      subject(:stats) { populated_registry.stats }

      it "has zeroed stats" do
        is_expected.to match total_links: 2,
                             total_assets: 2,
                             unfetched_links: 2
      end
    end
  end
end
