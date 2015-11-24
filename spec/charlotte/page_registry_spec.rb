require "spec_helper"

describe PageRegistry do
  subject(:registry) { PageRegistry.new }

  let(:links) { ["/a", "/"] }
  let(:assets) { ["/test2.png", "favicon.ico"] }
  let(:page) { double(Page, links: links, assets: assets) }

  let(:new_assets) { ["/test.png", "favicon.ico"] }
  let(:new_links) { ["/a", "/b"] }
  let(:new_page) { double(Page, links: new_links, assets: new_assets) }

  context "with an empty registry" do
    describe "#initialize" do
      it "initializes with the root url" do
        expect(subject.links).to match "/" => PageRegistry::NOT_FETCHED
      end
    end

    describe '#add' do
      before { subject.add(page) }

      it "it adds 2 links" do
        expect(subject.links.count).to eq 2
      end
      it "adds page links" do
        expect(subject.links).to match "/a" => PageRegistry::NOT_FETCHED,
                                       "/" => PageRegistry::NOT_FETCHED
      end
      it "adds page assets" do
        expect(subject.assets).to match assets
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
