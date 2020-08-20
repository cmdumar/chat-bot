require_relative './bot_data.rb'
require_relative '../config/environment.rb'

class Bot
  attr_reader :api_key, :time, :bot, :message
  include BotData
  def initialize(bot, message)
    @bot = bot
    @message = message
    @api_key = BotData::OPENWEATHER_API
    run_bot
  end

  private

  def run_bot
    str = message.text.split('/')[1]
    str = str.is_a?(NilClass) ? 'weather' : str
    case message.text.downcase
    when '/start'
      text = BotData.welcome(message.from.first_name)
      bot_api(text)
    when '/date'
      bot_api(BotData.date)
    when /^weather/
      weather(str)
    when /^covid/
      covid(str)
    when '/help'
      bot_api(BotData.help)
    else
      bot_api(BotData.unknown_command)
    end
  end

  def bot_api(text)
    bot.api.send_message(
      chat_id: message.chat.id,
      text: text,
      parse_mode: 'Markdown'
    )
  end

  def weather(str)
    if BotData.get_weather(api_key, str)
      text = BotData.weather_text(BotData.get_weather(api_key, str))
      bot_api(text)
    else
      bot_api(BotData.unknown_city)
    end
  end

  def covid(str)
    if BotData.covid_cases(str)
      text = BotData.covid_text(BotData.covid_cases(str))
      bot_api(text)
    else
      bot_api(BotData.unknown_country)
    end
  end
end
