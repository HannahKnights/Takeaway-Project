require 'rubygems'
require 'twilio-ruby'


class Takeaway

MENU = [
    {:name => "Apple, Rhubarb and Marshmallow Crumble", :price => 4},
    {:name => "Rhubarb and White Chocolate Mille-feuille", :price => 5},
    {:name => "Rhubarb and Vanilla Custard Panna Cotta", :price => 4.5},
    {:name => "Ginger poached Rhubarb with Thyme Yoghurt", :price => 3},
    {:name => "Rhubarb Sherbert", :price => 2.5}
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


  def count_order
    order = MENU.map do |item|
      counts[item[:name]] += 1
    end
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
      @basket.delete_if {|dessert| dessert[:name] == dish.to_s}
    end
    @basket
  end


  def order_total
    @total_price = @basket.map {|dish| dish[:price]}.reduce(:+)
  end


  def view_order
    view_order = Hash.new(0)
    @basket.each {|dish| view_order[dish[:name]] += 1 }
    view_order
  end


  def count_order
    counted = Hash.new(0)
    BASKET.each { |h| counted[h[:name]] += 1 }
    counted
  end


  def delivery_time
    delivery_time = Time.now + (60 * 1 * 60)
    "#{delivery_time.hour}:#{delivery_time.min}"
  end


  def delivery_message
    "Thanks for your The Rhu-bar order. It will be with you by #{delivery_time}. Enjoy!"
  end


  def send_text
    account_sid = 'AC6a0b7b977dcf9ca6e4bdae1f813c3374'
    auth_token = '74611c293510da907c789373a0d1e276'
    @client = Twilio::REST::Client.new account_sid, auth_token
    message = @client.account.messages.create(
      :body =>"#{delivery_message}",
      :to => "+447745578234",
      :from => "+441772367550",)
    puts message.to
  end

  def order_error
    raise "Sorry, there seems to be a problem with your order calculations"
  end


  def place_order(payment)
    order_total != payment ? order_error : send_text
  end


end

