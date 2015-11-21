require 'spec_helper'

describe PageRegistry do

  context 'with an empty registry' do
    subject { PageRegistry.new }

    let(:links) { [ "/a", "/" ] }
    let(:assets) { [ "/test.png", "favicon.ico" ] }
    let(:page) { double(Page, links: links, assets: assets) }

    describe '#add' do
      subject(:registry) do
        registry = PageRegistry.new
        registry.add(page)
        registry
      end

      it 'adds page links' do
        expect(registry.links.count).to eq 2
        expect(registry.links).to include "/a" => PageRegistry::NOT_FETCHED
        expect(registry.links).to include "/" => PageRegistry::NOT_FETCHED
      end
      it 'adds page assets' do
        expect(registry.links.count).to eq 2
      end
    end
  end
end
