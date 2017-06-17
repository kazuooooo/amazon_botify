module Bot
  class BotBase
    include Singleton
    def start_purchase(product, *args)
      raise "Please Define #start_purchase"
    end

    def succeed_to_purchase(product, *args)
      raise "Please Define #succeed_to_purchase"
    end

    def failed_to_purchase(product, *args)
      raise "Please Define #failed_to_purchase"
    end
  end
end