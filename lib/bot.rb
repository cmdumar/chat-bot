require 'telegram/bot'

class Bot
  def initialize
    @token = '1396281284:AAGXP51_X96VNnPmE_UZ944EZaN9lJ2Aq28'
    @appid = '0028ea367b25a551e7348f7875810282'
    @time = Time.new
  end

  def runBot
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hi, *#{message.from.first_name}*\n#{welcome}", parse_mode: 'Markdown')
        when '/date'
          bot.api.send_message(chat_id: message.chat.id, text: "Today's date is *#{@time.day}-#{@time.month}-#{@time.year}*", parse_mode: 'Markdown')
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Goodbye, #{message.from.first_name}")
        when (/^weather/)
          str = message.text.split('/')[1]
          if getWeather(str)
            bot.api.send_message(chat_id: message.chat.id, text: weatherText(str), parse_mode: 'Markdown')
          else
            bot.api.send_message(chat_id: message.chat.id, text: "City not found, please enter a valid city name.")
          end
        when (/^covid/)
          str = message.text.split('/')[1]
          if covidCases(str)
            bot.api.send_message(chat_id: message.chat.id, text: covidText(str), parse_mode: 'Markdown')
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Country not found or doesn't have any cases")
          end
        when '/help'
          bot.api.send_message(chat_id: message.chat.id, text: help, parse_mode: 'Markdown')
        else
          bot.api.send_message(chat_id: message.chat.id, text: 'I couldn\'t understand that command, please write a valid command.')
        end
      end
    end
  end

  private

  def getWeather(city)
    params = {
      :appid => @appid,
      :q => city,
      :units => 'metric'
    }
    uri = URI("https://api.openweathermap.org/data/2.5/weather")
    uri.query = URI.encode_www_form(params)
    json = Net::HTTP.get(uri)
    data = JSON.parse(json)
  
    return false if data['name'] == nil
  
    info = {
      city: data['name'],
      temp: data['main']['temp'],
      weather: data['weather'][0]['main'],
      humidity: data['main']['humidity'],
      wind: data['wind']['speed']
    }
    info
  end

  def covidCases(country)
    params = {
      :country => country
    }
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
      recovered: data['recovered'],
    }
    info
  end

  def weatherText(str)
  "Weather Now in __#{getWeather(str)[:city]}__\n
  Weather: *#{getWeather(str)[:weather]}* | Temperature: *#{getWeather(str)[:temp]} C*\n
  Humidity: *#{getWeather(str)[:humidity]}%* | Wind Speed: *#{getWeather(str)[:wind]} km/h*\n"
  end

  def covidText(str)
  "Today's Covid-19 Status for __#{covidCases(str)[:country]}__:\n
  Total Number of Cases: *#{covidCases(str)[:totalCases]}*\n
  Active Cases: *#{covidCases(str)[:activeCases]}*\n
  Critical Cases: *#{covidCases(str)[:critical]}*\n
  Recovered Cases: *#{covidCases(str)[:recovered]}*"
  end

  def welcome
    "\nI am a Weather and Covid-19 Bot\n
    You can know about the current weather of any city.\n
    You can know about the Covid-19 Cases and other info of any country.\n
    List of commands you can use in this bot:\n
    Covid-19 command: *covid/*`<replace me with country name>`\n
    Weather command: *weather/*`<replace me with city name>`\n
    Date command: /date (To know the date)"
  end

  def help
    "List of Commands: \n
    1. /start: Start the bot\n
    2. covid/_<country-name>_: Get Covid-19 details\n
    3. weather/_<city-name>_: Get today's weather\n
    4. /date: Get today's date\n
    5. /help: Get the list of all commands.\n
    How to get Covid-19 details for a country?\n
    Type `covid/usa` to get the details for United States\n
    How to get weather details for a city?\n
    Type `weather/london` to get the weather for London"
  end
end
