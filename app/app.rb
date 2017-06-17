require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./amazon_botify.db"
)

# order
class Order < ActiveRecord::Base

end

## list orders
get '/orders' do
  'Hello'
end

## execute order
post '/orders' do

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