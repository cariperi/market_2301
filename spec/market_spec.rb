require 'spec_helper'

describe Market do
  before(:each) do
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@market).to be_a Market
    end

    it 'has a name' do
      expect(@market.name).to eq("South Pearl Street Farmers Market")
    end

    it 'has vendors that start as empty by default' do
      expect(@market.vendors).to eq([])
      expect(@market.vendors).to be_a Array
    end
  end

  describe '#add_vendor' do
    it 'can add vendor objects to the market' do
      expect(@market.vendors).to eq([])

      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors.count).to eq(3)
      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
      expect(@market.vendors.sample).to be_a Vendor
    end
  end

  describe '#vendor_names' do
    it 'can return the names of all vendors at the market' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
      expect(@market.vendor_names).to be_a Array
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
  end

  describe '#vendors_that_sell' do
    it 'can return a list of vendor objects that sell a given item' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
      expect(@market.vendors_that_sell(@item1)).to be_a Array
      expect(@market.vendors_that_sell(@item1).sample).to be_a Vendor
    end
  end

  describe '#sorted_item_list' do
    it 'returns a sorted list of in-stock item names from all vendors' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sorted_item_list.count).to eq(4)
      expect(@market.sorted_item_list).to be_a Array
      expect(@market.sorted_item_list.sample).to be_a String
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", 'Peach', "Peach-Raspberry Nice Cream", 'Tomato'])
    end
  end

  describe '#total_inventory' do
    it 'returns an inventory for the market as a hash' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.total_inventory).to be_a Hash
      expect(@market.total_inventory.keys).to include(@item1, @item2, @item3, @item4)
      expect(@market.total_inventory.keys.count).to eq(4)
      expect(@market.total_inventory[@item1]).to be_a Hash
      expect(@market.total_inventory[@item1][:quantity]).to be_a Integer
      expect(@market.total_inventory[@item1][:quantity]).to eq(100)
      expect(@market.total_inventory[@item1][:vendors]).to be_a Array
      expect(@market.total_inventory[@item1][:vendors]).to eq([@vendor1, @vendor3])
      expect(@market.total_inventory[@item2]).to eq({:quantity => 7, :vendors => [@vendor1]})
    end
  end

  describe '#overstocked_items' do
    it 'lists items sold by more than 1 vendor with total stock over 50' do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.overstocked_items).to be_a Array
      expect(@market.overstocked_items).to eq([@item1])
      expect(@market.overstocked_items).to_not include(@item2, @item3, @item4)
    end
  end
end
