require_relative '../lib/bot.rb'

class StartBot
  def initialize
    run = Bot.new
    run.run_bot
  end
end

StartBot.new
