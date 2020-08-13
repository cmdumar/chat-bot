require_relative './messages.rb'
require_relative '../config/environment.rb'

class Bot
  attr_reader :appid, :time, :bot, :message
  include Messages
  def initialize(bot, message)
    @bot = bot
    @message = message
    @appid = ENV['OPENWEATHER_API']
    run_bot
  end

  private

  def run_bot
    str = message.text.split('/')[1]
    str = str.is_a?(NilClass) ? 'weather' : str
    case message.text.downcase
    when '/start'
      text = "Hi, *#{message.from.first_name}*\n#{Messages.welcome}"
      bot_api(text)
    when '/date'
      bot_api(Messages.date)
    when /^weather/
      weather(str)
    when /^covid/
      covid(str)
    when '/help'
      bot_api(Messages.help)
    else
      bot_api(Messages.unknown_command)
    end
  end

  def get_weather(city)
    params = {
      appid: @appid,
      q: city,
      units: 'metric'
    }
    uri = URI('https://api.openweathermap.org/data/2.5/weather')
    uri.query = URI.encode_www_form(params)
    json = Net::HTTP.get(uri)
    data = JSON.parse(json)

    return false if data['name'].nil?

    info = {
      city: data['name'],
      temp: data['main']['temp'],
      weather: data['weather'][0]['main'],
      humidity: data['main']['humidity'],
      wind: data['wind']['speed']
    }
    info
  end

  def covid_cases(country)
    country = country.include?(' ') ? country.split(' ').join('-') : country

    uri = URI("https://corona.lmao.ninja/v2/countries/#{country}")
    json = Net::HTTP.get(uri)
    data = JSON.parse(json)
    return false unless data['message'].nil?

    info = {
      country: data['country'],
      totalCases: data['cases'],
      activeCases: data['active'],
      critical: data['critical'],
      deaths: data['deaths'],
      recovered: data['recovered']
    }
    info
  end

  def bot_api(text)
    bot.api.send_message(
      chat_id: message.chat.id,
      text: text,
      parse_mode: 'Markdown'
    )
  end

  def weather(str)
    if get_weather(str)
      text = Messages.weather_text(get_weather(str))
      bot_api(text)
    else
      bot_api(Messages.unknown_city)
    end
  end

  def covid(str)
    if covid_cases(str)
      text = Messages.covid_text(covid_cases(str))
      bot_api(text)
    else
      bot_api(Messages.unknown_country)
    end
  end
end
