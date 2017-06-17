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

    def succeed_to_order(product, *args)
      client.files_upload(
          channels: '#general',
          as_user: true,
          file: Faraday::UploadIO.new("#{Dir.pwd}/order.png", 'image/png'),
          title: 'order screenshot',
          filename: 'order.jpg',
          initial_comment: "#{product.name}を購入しました。"
      )
    end

    private
    def send_message(message)
      client.chat_postMessage(channel: '#general', text: message)
    end
  end
end