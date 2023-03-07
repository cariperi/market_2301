class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    #@vendors.select{|vendor| vendor.inventory.keys.include?(item)}
    @vendors.select{|vendor| vendor.check_stock(item) != 0}
  end

  def sorted_item_list
    items = []
    @vendors.each do |vendor|
      vendor.inventory.each do |item, _|
        items << item.name if !items.include?(item.name)
      end
    end
    items.sort
  end

  def total_inventory
    total_inventory = {}
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        total_inventory[item] = {:quantity => 0, :vendors => []} if !total_inventory.keys.include?(item)
        total_inventory[item][:quantity] += amount
        total_inventory[item][:vendors] << vendor
      end
    end
    total_inventory
  end
end
