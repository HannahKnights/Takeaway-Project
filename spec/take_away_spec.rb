require 'take_away'
require 'rubygems'
require 'twilio-ruby'

describe Takeaway do

  let (:takeaway) {Takeaway.new}

  let (:time) {Time.at(Date.parse('2013-12-09').to_time.to_i + 15*30*30)}

  let (:basket_two_sherberts) {2.times{takeaway.add_to_basket("Rhubarb Sherbert")}}



  context "menu items" do

    # it's a bit of an overkill, don't test that it has menu
    # because if it doesn't, other tests will fail
    it "should have a menu" do
      expect(takeaway).to have_menu
    end

    it "should have a list of dishes on the menu" do
      expect(takeaway.dishes.first).to include "Marshmallow"
    end

    it "dishes should have a price" do
      expect(takeaway.price("Rhubarb Sherbert")).to eq(2.50)
    end

  end

  # Well done for implementing fairly complex functionality
  # even though it wasn't required
  context "Has a basket" do

    it "which can be empty" do
      expect(takeaway.basket).to be_empty
    end

    it "which can store an item" do
      takeaway.add_to_basket("Rhubarb Sherbert")
      expect(takeaway.basket).not_to be_empty
    end

    it "which can store more than one item" do
      basket_two_sherberts
      expect(takeaway.basket.count).to eq(2)
    end

    it "which you can remove items from" do
      takeaway.add_to_basket("Rhubarb Sherbert")
      takeaway.add_to_basket("Rhubarb and Vanilla Custard Panna Cotta")
      expect(takeaway.basket.count).to eq(2)
      takeaway.remove_from_basket("Rhubarb Sherbert")
      expect(takeaway.basket.count).to eq(1)
    end


    it "which can provide an order total of its items" do
      basket_two_sherberts
      expect(takeaway.order_total).to eq(5)
    end

    it "should calculate the quantities of each item in your basket" do
      basket_two_sherberts
      expect(takeaway.view_order.first).to include "Rhubarb Sherbert", 2 
    end

  end

  context "Placing an order" do

    it "should raise an error if the order total and customer's payment don't match" do
      basket_two_sherberts
      takeaway.add_to_basket("Rhubarb and Vanilla Custard Panna Cotta")
      expect(lambda {takeaway.place_order(5)}).to raise_error "Sorry, there seems to be a problem with your order calculations" 
    end
  
    it "should know that the order will arrive in one hour" do
      allow(Time).to receive(:now).and_return(time)      
      expect(takeaway.delivery_time).to eq('4:45')
    end

    it "should include the delivery time in the text message to the customer" do
      allow(Time).to receive(:now).and_return(time)
      expect(takeaway.delivery_message).to eq("Thanks for your The Rhu-bar order. It will be with you by 4:45. Enjoy!")
    end


    it "should send a text to tell the customer the order is on the way" do
      takeaway.stub(:send_text) 
      basket_two_sherberts
      takeaway.should_receive(:send_text).once
      takeaway.place_order(5)
    end

  end

end