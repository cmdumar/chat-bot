require 'telegram/bot'
require_relative '../lib/bot.rb'

class StartBot
  attr_reader :token
  def initialize
    puts "Bot is running!"
    @token = '1396281284:AAGXP51_X96VNnPmE_UZ944EZaN9lJ2Aq28'
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        Bot.new(bot, message).run_bot
      end
    end
  end
end

StartBot.new
