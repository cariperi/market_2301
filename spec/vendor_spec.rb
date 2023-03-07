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

    it 'can return the amount of a given item if it is in stock' do
      @vendor.stock(@item1, 30)
      expect(@vendor.check_stock(@item1)).to eq(30)

      @vendor.stock(@item1, 25)
      expect(@vendor.check_stock(@item1)).to eq(55)

      @vendor.stock(@item2, 12)
      expect(@vendor.check_stock(@item2)).to eq(12)
    end
  end

  describe '#stock' do
    it 'can add items and amounts to the vendors inventory' do
      expect(@vendor.inventory).to eq({})

      @vendor.stock(@item1, 30)

      expect(@vendor.inventory).to eq({@item1 => 30})

      @vendor.stock(@item1, 25)
      @vendor.stock(@item2, 12)

      expect(@vendor.inventory).to eq({@item1 => 55, @item2 => 12})
    end

    it 'can update the amount of an item that is in the inventory' do
      @vendor.stock(@item1, 30)
      expect(@vendor.inventory).to eq({@item1 => 30})

      @vendor.stock(@item1, 25)
      expect(@vendor.inventory).to eq({@item1 => 55})
    end
  end
end
