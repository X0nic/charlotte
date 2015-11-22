require 'spec_helper'

describe PageRegistry do

  let(:links) { [ "/a", "/" ] }
  let(:assets) { [ "/test2.png", "favicon.ico" ] }
  let(:page) { double(Page, links: links, assets: assets) }

  let(:new_assets) { [ "/test.png", "favicon.ico" ] }
  let(:new_links) { [ "/a", "/b" ] }
  let(:new_page) { double(Page, links: new_links, assets: new_assets) }

  context 'with an empty registry' do
    subject { PageRegistry.new }

    describe '#add' do
      before { subject.add(page) }

      it 'it adds 2 links' do
        expect(subject.links.count).to eq 2
      end
      it 'adds page links' do
        expect(subject.links).to include "/a" => PageRegistry::NOT_FETCHED
        expect(subject.links).to include "/" => PageRegistry::NOT_FETCHED
      end
      it 'adds page assets' do
        expect(subject.assets.count).to eq 2
      end
    end
  end

  context 'with a populated registry' do
    subject do
      registry = PageRegistry.new
      registry.add(page)
      registry
    end

    describe '#add' do
      before do
        subject.add(new_page)
        subject.uri_fetched("/a")
      end

      it 'it adds 1 new link' do
        expect(subject.links.count).to eq 3
      end
      it 'does not overwrite existing links' do
        expect(subject.links).to include "/a" => PageRegistry::FETCHED
        expect(subject.links).to include "/b" => PageRegistry::NOT_FETCHED
        expect(subject.links).to include "/" => PageRegistry::NOT_FETCHED
      end
      it 'adds 1 new page asset' do
        expect(subject.assets.count).to eq 3
      end
    end
  end
end
