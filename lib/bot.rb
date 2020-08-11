require 'telegram/bot'

class Bot
  def initialize
    @token = '1396281284:AAGXP51_X96VNnPmE_UZ944EZaN9lJ2Aq28'
    @appid = '0028ea367b25a551e7348f7875810282'
  end

  def runBot
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "How are you, #{message.from.first_name}")
        when '/time'
          bot.api.send_message(chat_id: message.chat.id, text: "Time is #{Time.now}, #{message.from.first_name}")
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Goodbye, #{message.from.first_name}")
        when (/^weather/)
          str = message.text.split('/')[1]
          if getWeather(str)
            bot.api.send_message(chat_id: message.chat.id, text: weatherText(str))
          else
            bot.api.send_message(chat_id: message.chat.id, text: "City not found, please enter a valid city name.")
          end
        when (/^covid/)
          str = message.text.split('/')[1]
          if covidCases(str)
            bot.api.send_message(chat_id: message.chat.id, text: covidText(str))
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Country not found or doesn't have any cases")
          end
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
      humidity: data['main']['humidity']
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
    return "Weather Now in #{getWeather(str)[:city]}\n#{getWeather(str)[:weather]}
Temperature: #{getWeather(str)[:temp]} C\nHumidity: #{getWeather(str)[:humidity]}%\n"
  end

  def covidText(str)
    return "Today's Covid-19 Status for #{covidCases(str)[:country]}:\n
Total Number of Cases: #{covidCases(str)[:totalCases]}\n
Active Cases: #{covidCases(str)[:activeCases]}\n
Critical Cases: #{covidCases(str)[:critical]}\n
Recovered Cases: #{covidCases(str)[:recovered]}"
  end
end
