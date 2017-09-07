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
      send_message("商品名: #{product.name}, URL: #{product.url} を登録しました")
    end

    def delete_product(product)
      send_message("商品名: #{product.name}を削除しました")
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
      "注文履歴\n\n"
    end

    def order_row(order)
      # HACK: localのタイムゾーンがうまく取れない
      "#{(order.ordered_at + Time.now.gmt_offset).strftime("%Y年%m月%d日 %H:%M")} : #{order.product.name}"
    end

    def products_header
      "登録商品一覧\n\n"
    end

    def product_row(product)
      "名前: #{product.name} URL: #{product.url}"
    end

    def howto
      howto = <<~HOWTO
        ・az 追加 商品名 商品ID → 商品追加
        (商品IDは https://www.amazon.co.jp/dp/xxxxx のxxxxxの部分)
        ・az 削除 商品名 　　　→ 商品削除
        ・az 一覧              → 商品一覧の取得
        ・az 履歴  　          → 注文履歴の取得
        ・az 注文 商品名           → 商品注文
        ・az 使い方               → 使い方
      HOWTO
      send_message(howto)
    end
  end
end