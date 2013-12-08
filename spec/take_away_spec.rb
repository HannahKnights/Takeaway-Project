require 'take_away'

describe Takeaway do

  let (:takeaway) {Takeaway.new}

  context "menu items" do

    it "should have a menu" do
      takeaway
      expect(takeaway).to have_menu
    end

    it "should have a list of dishes on the menu" do
      takeaway
      expect(takeaway.dishes.first).to include "Marshmallow"
    end

    it "dishes should have a price" do
      takeaway
      expect(takeaway.price("Rhubarb Sherbert")).to eq(2.50)
    end

  end

  context "Has a basket" do

    it "which can be empty" do
      takeaway
      expect(takeaway.basket).to be_empty
    end

    it "which can store an item" do
      takeaway
      takeaway.add_to_basket("Rhubarb Sherbert")
      expect(takeaway.basket).not_to be_empty
    end

    it "which can store more than one item" do
      takeaway
      takeaway.add_to_basket("Rhubarb Sherbert")
      takeaway.add_to_basket("Rhubarb Sherbert")
      expect(takeaway.basket.count).to eq(2)
    end

    it "which you can remove items from" do
      takeaway
      takeaway.add_to_basket("Rhubarb Sherbert")
      expect(takeaway.basket.count).to eq(1)
      takeaway.remove_from_basket("Rhubarb Sherbert")
      expect(takeaway.basket.count).to eq(0)
    end

    it "which can provide a total of its items" do
      takeaway
      2.times{takeaway.add_to_basket("Rhubarb Sherbert")}
      expect(takeaway.order_total).to eq(5)
    end


  end

  context "Placing an order" do

    xit "should raise an error if the basket total is incorrect" do
      takeaway.stub(:order_total) {2}
      takeaway
      2.times{takeaway.add_to_basket("Rhubarb Sherbert")}
      takeaway.add_to_basket("Rhubarb and Vanille Custard Panna Cotta")
      expect(takeaway.place_order).to raise_error
    end
  

  end

end