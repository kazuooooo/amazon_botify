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
      belongs_to :product
      default_scope { order(ordered_at: :desc) }
    end

    ## list orders
    get '/orders' do
      begin
        @bot.get_orders(Order.all)
        status 200
        body ''
      rescue => e
        @bot.fail("オーダー一覧の取得", e.message)
        status 500
        body "#{e.message}"
      end
    end

    ## execute order
    post '/orders' do
      product = Product.find_by(name: params[:name])
      # begin
        @bot.post_orders(product) do |product|
          WebDriver.instance.order(product.amazon_product_id, self.class.production?)
          product.orders.create!(ordered_at: Time.now)
        end
        status 200
        body ''
      # rescue => e
      #   @bot.fail("#{product.name}の購入", e.message)
      #   status 500
      #   body "#{e.message}"
      # end
    end

    ## cancel order
    delete '/orders/:id' do

    end

    # products
    class Product < ActiveRecord::Base
      has_many :orders
    end

    ## list products
    get '/products' do
      begin
        @bot.get_products(Product.all)
        status 200
        body ''
      rescue => e
        @bot.fail("商品一覧の取得", e.message)
        status 500
        body "#{e.message}"
      end
    end

    ## add product
    post '/products' do
      begin
        product = Product.create!(name: params[:name], amazon_product_id: params[:amazon_product_id])
        @bot.post_products(product)
        status 200
      rescue => e
        status 500
        body "#{e.message}"
      end
    end

    ## edit product
    put '/products/:id' do
    end

    ## delete product
    delete '/products/:id' do
    end
  end
end
