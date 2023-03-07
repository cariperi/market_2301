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
        total_inventory[item][:vendors] = vendors_that_sell(item)
      end
    end
    total_inventory
  end

  def overstocked_items
    overstocked_items = []
    total_inventory.map do |item, _|
      if high_quantity?(item) && multiple_vendors?(item)
        overstocked_items << item
      end
    end
    overstocked_items
  end

  def multiple_vendors?(item)
    return false if vendors_that_sell(item).empty?
    total_inventory[item][:vendors].count > 1
  end

  def high_quantity?(item)
    total_inventory[item][:quantity] > 50
  end

  def sell(item, quantity)
    if total_inventory[item][:quantity] < quantity
      return false
    elsif total_inventory[item][:quantity] >= quantity
      fulfilled = 0
      until fulfilled == quantity
        vendors_that_sell(item).each do |vendor|
          while vendor.inventory[item] > 0 && fulfilled < quantity
            vendor.inventory[item] -= 1
            fulfilled += 1
          end
        end
      end
      return true
    end
  end
end
