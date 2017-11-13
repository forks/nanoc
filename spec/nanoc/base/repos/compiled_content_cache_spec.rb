# frozen_string_literal: true

describe Nanoc::Int::CompiledContentCache do
  let(:cache) { described_class.new(items: items, site: site) }

  let(:items) { [item] }

  let(:item) { Nanoc::Int::Item.new('asdf', {}, '/foo.md') }
  let(:item_rep) { Nanoc::Int::ItemRep.new(item, :default) }

  let(:other_item) { Nanoc::Int::Item.new('asdf', {}, '/sneaky.md') }
  let(:other_item_rep) { Nanoc::Int::ItemRep.new(other_item, :default) }

  let(:content) { Nanoc::Int::Content.create('omg') }

  let(:site) do
    Nanoc::Int::Site.new(
      config: Nanoc::Int::Configuration.new.with_defaults,
      code_snippets: [],
      data_source: Nanoc::Int::InMemDataSource.new(items, []),
    )
  end

  it 'has no content by default' do
    expect(cache[item_rep]).to be_nil
  end

  context 'setting content on known item' do
    before { cache[item_rep] = { last: content } }

    it 'has content' do
      expect(cache[item_rep][:last].string).to eql('omg')
    end

    context 'after storing and loading' do
      before do
        cache.store
        cache.load
      end

      it 'has content' do
        expect(cache[item_rep][:last].string).to eql('omg')
      end
    end
  end

  context 'setting content on unknown item' do
    before { cache[other_item_rep] = { last: content } }

    it 'has content' do
      expect(cache[other_item_rep][:last].string).to eql('omg')
    end

    context 'after storing and loading' do
      before do
        cache.store
        cache.load
      end

      it 'has no content' do
        expect(cache[other_item_rep]).to be_nil
      end
    end
  end
end
