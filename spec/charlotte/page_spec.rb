require "spec_helper"

describe Page do
  let(:domain) { "duckduckgo.com" }
  let(:html) { load_page(domain, "/") }
  subject(:page) { Page.new("/", html) }

  context "when a vaild page" do
    let(:links) { ["/about", "/spread", "/tour"] }
    let(:assets) do
      [
        "/assets/icons/meta/DDG-iOS-icon_120x120.png",
        "/assets/icons/meta/DDG-iOS-icon_152x152.png",
        "/assets/icons/meta/DDG-iOS-icon_60x60.png",
        "/assets/icons/meta/DDG-iOS-icon_76x76.png",
        "/assets/icons/meta/DDG-icon_256x256.png",
        "/favicon.ico",
        "/opensearch.xml",
        "/s1049.css",
        "/t1049.css"
      ]
    end

    it { expect(page.url).to eq "/" }
    describe "#links" do
      it "has 3 links" do
        expect(page.links.count).to eq 3
      end
      it "has all links" do
        expect(page.links).to match_array links
      end
    end
    describe "#assets" do
      it "has 10 assets" do
        expect(page.assets.count).to eq 9
      end
      it "has all links" do
        expect(page.assets).to match_array assets
      end
    end
  end
end
