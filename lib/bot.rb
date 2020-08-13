require_relative './messages.rb'

class Bot
  attr_reader :appid, :time, :bot, :message
  include Messages
  def initialize(bot, message)
    @bot = bot
    @message = message
    @appid = '0028ea367b25a551e7348f7875810282'
    @time = Time.new
  end

  def run_bot
    str = message.text.split('/')[1]
    str = str.is_a?(NilClass) ? 'weather' : str
    case message.text.downcase
    when '/start'
      start_msg
    when '/date'
      msg_placeholder(Messages.date)
    when '/stop'
      stop_msg
    when /^weather/
      weather(str)
    when /^covid/
      covid(str)
    when '/help'
      msg_placeholder(Messages.help)
    else
      msg_placeholder(Messages.unknown_command)
    end
  end

  private

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

  def start_msg
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "Hi, *#{message.from.first_name}*\n#{Messages.welcome}",
      parse_mode: 'Markdown'
    )
  end

  def stop_msg
    bot.api.send_message(
      chat_id: message.chat.id,
      text: "Goodbye, #{message.from.first_name}",
      parse_mode: 'Markdown'
    )
  end

  def weather(str)
    if get_weather(str)
      bot.api.send_message(
        chat_id: message.chat.id,
        text: Messages.weather_text(get_weather(str)),
        parse_mode: 'Markdown'
      )
    else
      msg_placeholder(Messages.unknown_city)
    end
  end

  def covid(str)
    if covid_cases(str)
      bot.api.send_message(
        chat_id: message.chat.id,
        text: Messages.covid_text(covid_cases(str)),
        parse_mode: 'Markdown'
      )
    else
      msg_placeholder(Messages.unknown_country)
    end
  end

  def msg_placeholder(msg)
    bot.api.send_message(
      chat_id: message.chat.id,
      text: msg,
      parse_mode: 'Markdown'
    )
  end
end
