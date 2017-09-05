require 'bundler'
Bundler.require

module AmazonBotify
  class Application < Sinatra::Base
    Time.zone = "Tokyo"
    ActiveRecord::Base.default_timezone = :local
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
    post '/order_index' do
      begin
        @bot.get_orders(Order.all)
        status 200
        body ''
      rescue => e
        @bot.fail("注文履歴の取得", e.message)
        status 500
        body "#{e.message}"
      end
    end

    ## execute order
    post '/orders' do
      begin
        product_name =  @bot.get_product_name(params)
        product = Product.find_by!(name: product_name.gsub("\b", "")) #HACKin
        @bot.post_orders(product) do |product|
          # WebDriver.new.order(product.amazon_product_id, true) #tmp
          WebDriver.new.order(product.amazon_product_id, true)
          product.orders.create!(ordered_at: Time.now)
        end
        status 200
        body ''
      rescue => e
        @bot.fail("#{product_name}の購入", e.message)
        @bot.get_products(Product.all)
        status 500
        body "#{e.message}"
      end
    end

    ## cancel order
    delete '/orders/:id' do

    end

    # products
    class Product < ActiveRecord::Base
      has_many :orders
        def url
          "https://#{ENV['AMAZON_BOT_DOMAIN']}/dp/#{amazon_product_id}"
        end
    end

    ## list products
    post '/product_index' do
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
        product_name = @bot.get_product_name(params)
        product_id   = @bot.get_product_id(params)
        product = Product.create!(name: product_name, amazon_product_id: product_id)
        @bot.post_products(product)
        status 200
      rescue => e
        status 500
        body "#{e.message}"
      end
    end

    #  delete product
    post '/delete_products' do
      begin
        product_name = @bot.get_product_name(params)
        product = Product.find_by(name: product_name).destroy
        @bot.delete_product(product)
        status 200
      rescue => e
      end
    end


    ## edit product
    put '/products/:id' do
    end

    ## delete product
    delete '/products/:id' do
    end

    # howto
    post '/howto' do
      begin
        @bot.howto
        status 200
      rescue => e
        status 500
        body "#{e.message}"
      end
    end
  end
end
