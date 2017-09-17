Slack.configure do |config|
  config.token = ENV['AMAZON_BOT_SLACK_TOKEN']
end

module Bot
  class SlackBot < BotBase

    attr_accessor :client
    CHANNEL_NAME = '#amazon_botify'
    def initialize
      @client = Slack::Web::Client.new
    end

    def succeed_to_order(product, *args)
      client.files_upload(
          channels: CHANNEL_NAME,
          as_user: false,
          file: Faraday::UploadIO.new("#{Dir.pwd}/order.png", 'image/png'),
          title: 'order screenshot',
          filename: 'order.jpg',
          initial_comment: "#{product.name}を購入しました。"
      )
    end

    def get_product_name(params)
      params["text"].split(" ")[2]
    end

    def get_product_id(params)
      params["text"].split(" ")[3]
    end

    private
    def send_message(message)
      client.chat_postMessage(channel: CHANNEL_NAME, text: message)
    end
  end
end