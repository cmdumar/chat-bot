require_relative '../lib/bot.rb'
require_relative '../lib/weather.rb'

class StartBot
  def initialize
    run = Bot.new
    run.runBot
  end
end

StartBot.new