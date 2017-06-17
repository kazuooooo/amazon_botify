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

# order
class Order < ActiveRecord::Base

end

## list orders
get '/orders' do
  ss = WebDriver.instance.order(4388062367, self.class.production?)
  Bot::SlackBot.instance.succeed_to_purchase(ss)
  "so good"
end

## execute order
post '/orders' do
  amazon_product_id = params[:amazon_product_id]
  WebDriver.instance.order(amazon_product_id)
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