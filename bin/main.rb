require_relative '../lib/bot.rb'

class StartBot
  def initialize
    run = Bot.new
    run.runBot
  end
end

StartBot.new