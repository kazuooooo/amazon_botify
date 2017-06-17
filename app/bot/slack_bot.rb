require 'pry'
Slack.configure do |config|
  config.token = ENV['AMAZON_BOT_SLACK_TOKEN']
end

module Bot
  class SlackBot < BotBase

    attr_accessor :client
    def initialize
      @client = Slack::Web::Client.new
    end

    def start_order(product, *args)
      post_message("#{product.name}を購入します。")
    end

    def succeed_to_purchase(product, *args)
      client.files_upload(
          channels: '#general',
          as_user: true,
          file: Faraday::UploadIO.new("#{Dir.pwd}/order.png", 'image/png'),
          title: 'order screenshot',
          filename: 'order.jpg',
          initial_comment: "#{product.name}を購入しました。"
      )
    end

    def failed_to_purchase(product, *args)
      post_message("#{product.name}を購入に失敗しました。 #{args[0]}")
    end

    private
    def post_message(message)
      client.chat_postMessage(channel: '#general', text: message)
    end
  end
end