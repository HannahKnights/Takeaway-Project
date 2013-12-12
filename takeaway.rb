require 'sinatra'
require_relative './lib/take_away'

enable :sessions
# configure(:development) { set :session_secret, "something" }

before do
  @takeaway ||= Takeaway.new(session[:basket])
  # @basket = takeaway.basket
end

# before do
#   @basket = session[:basket]
# end

def menu_display
  @takeaway.dishes
end


get '/'  do
  @takeaway_d = @takeaway.menu
  @menu = menu_display
  # session[:takeaway] = @takeaway.new
  session[:basket] = @takeaway.basket
  @b = @takeaway.basket
  puts @b.inspect
  erb :index
end

post '/' do
  # raise 'dfds'
  # session[:basket] = 
  session[:basket] = @takeaway.add_to_basket(params["dish"])
  puts @takeaway.basket.inspect
  # session[:basket] = @basket
  redirect to '/'
end

delete '/' do
  session[:basket] = @takeaway.remove_from_basket(params["dish"])
  redirect to '/'
end

# get '/basket' do
# session[:basket] = @takeaway.basket
# erb :basket
# end


