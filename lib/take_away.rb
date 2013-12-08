class Takeaway

MENU = [
    {:name => "dish", :price => 1},
    {:name => "dish2", :price => 1},
    {:name => "fish", :price => 1},
    {:name => "rish", :price => 1},
    {:name => "7ish", :price => 1}
  ]

  def initialize
    @basket = []
  end

  def basket
    @basket
  end

  def has_menu?
    MENU
  end

  def dishes
    menu_items = []
    MENU.each_with_index do |item, index|
     menu_items << "#{index+1}: #{item[:name]}...............£#{item[:price]}"
   end
   menu_items
  end

  def price(dish)
    MENU.each do |item|
      return item[:price] if item[:name] == dish.to_s
    end
  end

  def add_to_basket(dish)
    MENU.each do |item|
      @basket << item if item[:name] == dish.to_s
    end
    @basket
  end

  def remove_from_basket(dish)
    @basket.each do |item|
      @basket.delete_if {item[:name] == dish.to_s}
    end
    @basket
  end

  def order_total
    total_price = []
    @basket.each do |item|
      total_price << item[:price]
    end
    total_price.inject(0) {|sum, price| sum + price}
  end

end

