module Bot
  class BotBase
    include Singleton
    # order
    ## list orders
    def get_orders(orders)
      header = orders_header
      rows   = orders.map{|o| order_row(o)}.join("\n")
      send_message(header + rows)
    end

    # post orders
    def post_orders(product)
      start_order(product)
      yield(product)
      succeed_to_order(product)
    end


    def get_products(products)
      header = products_header
      rows   = products.map{|p| product_row(p)}.join("\n")
      send_message(header + rows)
    end

    def post_products(product, *args)
      send_message("商品名: #{product.name}, ID: #{product.amazon_product_id}で登録しました")
    end

    def fail(action, error_message)
      send_message("#{action}に失敗しました。 #{error_message}")
    end

    def start_order(product, *args)
      send_message("#{product.name}を購入します。")
    end

    def succeed_to_order(product, *args)
      send_message("#{product.name}を購入しました。")
    end

    def orders_header
      "オーダー一覧\n\n"
    end

    def order_row(order)
      "#{order.ordered_at.strftime("%Y年%m月%d日 %H:%M")} : #{order.product.name}"
    end

    def products_header
      "商品一覧\n\n"
    end

    def product_row(product)
      "名前: #{product.name} ID: #{product.amazon_product_id}"
    end
  end
end