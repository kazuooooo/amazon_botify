$LOAD_PATH << Dir.pwd
require './app'
require 'webdriver'
require 'bot/bot_base'
require 'bot/slack_bot'
require 'singleton'
run AmazonBotify::Application