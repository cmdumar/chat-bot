require 'telegram/bot'
require_relative '../lib/bot.rb'
require_relative '../lib/bot_data.rb'
require_relative '../config/environment.rb'

class StartBot
  attr_reader :token
  def initialize
    puts 'Bot is running!'
    @token = BotData::TELEGRAM_TOKEN
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        Bot.new(bot, message)
      end
    end
  end
end

StartBot.new
