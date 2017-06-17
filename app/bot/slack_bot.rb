require 'slack-ruby-client'
require 'bot/bot_base'
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
      client.chat_postMessage(channel: '#general', text: 'xxxを購入します', as_user: true)
    end

    def succeed_to_purchase(*args)
      client.files_upload(
          channels: '#general',
          as_user: true,
          file: Faraday::UploadIO.new("#{Dir.pwd}/order.png", 'image/png'),
          title: 'My Avatar',
          filename: 'avatar.jpg',
          initial_comment: 'xxxを購入しました。'
      )
    end

    def failed_to_purchase
      raise "Please Define #failed_to_purchase"
    end
  end
end