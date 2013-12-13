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


get '/'  do
  @takeaway_d = @takeaway.menu
  @menu = menu_display
  session[:basket] = @takeaway.basket
  erb :index
end

post '/' do
  session[:basket] = @takeaway.add_to_basket(params["dish"])
  puts @takeaway.basket.inspect
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


