require 'sinatra'
require_relative './lib/take_away'

enable :sessions

before do
  session[:basket] = session[:basket] || []
  @takeaway ||= Takeaway.new(session[:basket])
end


def menu_display
  @takeaway.dishes
end


def order_process(amount)
  if (amount).to_f == @takeaway.order_total 
    place_that_order(amount)
  else
    try_again(amount)
  end
end

def place_that_order(amount)
  @notice = "y"
  @takeaway.place_order(amount)
  session[:basket] = []
  session[:notice] = "Thank you for your Rhu-bar-b order"
end

def try_again(amount)
  session[:notice] = "Sorry the value you placed was incorect, please try again"
end


get '/'  do
  @takeaway_d = @takeaway.menu
  @menu = menu_display
  session[:basket] = @takeaway.basket
  @notice = session[:notice]
  erb :index
end

post '/' do
  session[:basket] = @takeaway.add_to_basket(params["dish"])
  # puts @takeaway.basket.inspect
  # puts "#{params["dish"]}"
  redirect to '/'
end

delete '/' do
  puts "#{params["dish"]}"
  session[:basket] = @takeaway.remove_from_basket(params["dish"])
  redirect to '/'
end

get'/checkout' do
  session[:basket] = @takeaway.basket
  erb :checkout
end

post '/payment' do
  amount = params["amount"]
  order_process(amount)
  # session[:notice] = "hi"
  # @takeaway.place_order(params["amount"])
  # session[:basket] = []
  redirect to '/'
end

def hello
 "hello"
end

# get '/basket' do
# session[:basket] = @takeaway.basket
# erb :basket
# end

helpers do


end

