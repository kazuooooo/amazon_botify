require './initializer'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require 'webdriver'
require 'bot/slack_bot'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./amazon_botify.db"
)

before do
  @bot = Bot::SlackBot.instance
end

# order
class Order < ActiveRecord::Base

end

## list orders
get '/orders' do
end

## execute order
post '/orders' do
  @bot.start_order(product)
  amazon_product_id = params[:amazon_product_id]
  WebDriver.instance.order(amazon_product_id, self.class.production?)
  @bot.succeed_to_purchase(ss)
end

## cancel order
delete '/orders/:id' do

end

# products
class Product < ActiveRecord::Base

end

## list products
get '/products' do

end

## add product
post '/products' do

end

## edit product
put '/products/:id' do

end

## delete product
delete '/products/:id' do

end