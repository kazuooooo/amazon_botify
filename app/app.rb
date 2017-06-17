require 'bundler'
Bundler.require

module AmazonBotify
  class Application < Sinatra::Base

    configure do
      register Sinatra::ActiveRecordExtension
      set :database, {adapter: "sqlite3", database: "db/amazon_botify_developmemt.db"}
    end

    configure :development do
      register Sinatra::Reloader
    end

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
      product = Product.find_by(name: params[:name])
      begin
        @bot.start_order(product)
        WebDriver.instance.order(product.amazon_product_id, self.class.production?)
        @bot.succeed_to_purchase(product)
        status 200
        body ''
      rescue => e
        @bot.failed_to_purchase(product, e.message)
        status 500
      end
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
      Product.create!(params[:name], params[:url])
    end

    ## edit product
    put '/products/:id' do

    end

    ## delete product
    delete '/products/:id' do

    end
  end
end
