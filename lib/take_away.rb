require 'rubygems'
require 'twilio-ruby'


class Takeaway

MENU = [
    {:name => "Apple, Rhubarb and Marshmallow Crumble", :price => 4},
    {:name => "Rhubarb and White Chocolate Mille-feuille", :price => 5},
    {:name => "Rhubarb and Vanilla Custard Panna Cotta", :price => 4.50},
    {:name => "Ginger poached Rhubarb with Thyme Yoghurt", :price => 3},
    {:name => "Rhubarb Sherbert", :price => 2.50}
  ]

  def menu
    MENU
  end


  def initialize(basket = [])
    @basket = basket
  end


  attr_reader :basket


  def dishes
    menu_items = []
    MENU.each_with_index do |item, index|
     menu_items << "#{index+1}: #{item[:name]}...............£#{sprintf '%.2f' % item[:price]}"
   end
   menu_items
  end


  def price(dish)
    item = MENU.detect{|item| item[:name] == dish.to_s}
    item[:price] if item
  end


  def add_to_basket(dish)
    item = MENU.detect{|item| item[:name] == dish.to_s}
    @basket << item if item
  end

  def remove_from_basket(dish)
    first_instance = @basket.index {|item| item[:name] == dish.to_s}
    @basket.delete_at(first_instance)
    @basket
  end

  def order_total
    @total_price = @basket.map {|dish| dish[:price]}.reduce(:+)
  end


  def view_order
    @basket.inject(Hash.new {0}) do |order, dish|
      order[dish[:name]] += 1
      order
    end
  end


  def delivery_time
    delivery_time = Time.now + (60 * 1 * 60)
    "#{delivery_time.hour}:#{delivery_time.min}"
  end


  def delivery_message
    "Thanks for your The Rhu-bar order. It will be with you by #{delivery_time}. Enjoy!"
  end

  def send_text
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    message = @client.account.messages.create(
      :body =>"#{delivery_message}",
      :to => ENV['MY_PHONE_NUMBER'],
      :from => "+441772367550",)
    message.to
  end

  def order_error
    raise "Sorry, there seems to be a problem with your order calculations"
  end


  def place_order(payment)
    order_total != payment.to_f ? order_error : send_text
  end


end

