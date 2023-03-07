require 'spec_helper'

describe Vendor do
  before(:each) do
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
  end

  describe '#initialize' do
    it 'exists' do
      expect(@vendor).to be_a Vendor
    end

    it 'has a name' do
      expect(@vendor.name).to eq("Rocky Mountain Fresh")
    end

    it 'has inventory that starts empty by default' do
      expect(@vendor.inventory).to eq({})
      expect(@vendor.inventory).to be_a Hash
    end
  end

  describe '#check_stock' do
    it 'returns zero if the item is not in stock' do
      expect(@vendor.inventory).to eq({})
      expect(@vendor.check_stock(@item1)).to eq(0)
    end
  end
end
