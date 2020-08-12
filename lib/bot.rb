require 'telegram/bot'
require_relative './messages.rb'

class Bot
  include Messages
  def initialize
    @token = '1396281284:AAGXP51_X96VNnPmE_UZ944EZaN9lJ2Aq28'
    @appid = '0028ea367b25a551e7348f7875810282'
    @time = Time.new
  end

  def run_bot
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Hi, *#{message.from.first_name}*\n#{Messages.welcome}",
            parse_mode: 'Markdown'
          )
        when '/date'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Today's date is *#{@time.day}-#{@time.month}-#{@time.year}*",
            parse_mode: 'Markdown'
          )
        when '/stop'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: "Goodbye, #{message.from.first_name}"
          )
        when /^weather/
          str = message.text.split('/')[1]
          if get_weather(str)
            bot.api.send_message(
              chat_id: message.chat.id,
              text: Messages.weather_text(get_weather(str)),
              parse_mode: 'Markdown'
            )
          else
            bot.api.send_message(
              chat_id: message.chat.id,
              text: 'City not found, please enter a valid city name.'
            )
          end
        when /^covid/
          str = message.text.split('/')[1]
          if covid_cases(str)
            bot.api.send_message(
              chat_id: message.chat.id,
              text: Messages.covid_text(covid_cases(str)),
              parse_mode: 'Markdown'
            )
          else
            bot.api.send_message(
              chat_id: message.chat.id,
              text: "Country not found or doesn't have any cases"
            )
          end
        when '/help'
          bot.api.send_message(
            chat_id: message.chat.id,
            text: Messages.help,
            parse_mode: 'Markdown'
          )
        else
          bot.api.send_message(
            chat_id: message.chat.id,
            text: 'I couldn\'t understand that command, please write a valid command.'
          )
        end
      end
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
end
