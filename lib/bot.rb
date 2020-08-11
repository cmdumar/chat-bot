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
          str = message.text.split('/')
          if getWeather(str[1])
            bot.api.send_message(chat_id: message.chat.id, text: "Weather in #{getWeather(str[1])[:name]} is, #{getWeather(str[1])[:temp]}")
          else
            bot.api.send_message(chat_id: message.chat.id, text: "City not found, please enter a valid city name.")
          end
        when (/^covid/)
          str = message.text.split('/')
          if covidCases(str[1])
            bot.api.send_message(chat_id: message.chat.id,
              text: covidText(covidCases(str[1])[:totalCases],
              covidCases(str[1])[:country],
              covidCases(str[1])[:activeCases],
              covidCases(str[1])[:deaths],
              covidCases(str[1])[:recovered],
              covidCases(str[1])[:critical]))
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Country not found, please enter a valid country name.")
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
    api_response = JSON.parse(json)
  
    return false if api_response['name'] == nil
  
    info = {
      name: api_response['name'],
      temp: api_response['main']['temp']
    }
    info
  end

  def covidCases(country)
    params = {
      :country => country
    }
    uri = URI("https://corona.lmao.ninja/v2/countries/#{country}")
    # uri.query = URI.encode_www_form(params)
    json = Net::HTTP.get(uri)
    api_response = JSON.parse(json)
  
    return false unless api_response['message'].nil?

    info = {
      country: api_response['country'],
      totalCases: api_response['cases'],
      activeCases: api_response['active'],
      critical: api_response['critical'],
      deaths: api_response['deaths'],
      recovered: api_response['recovered'],
    }
    info
  end

  def covidText(totalCases, country, activeCases, deaths, recovered, critical)
    return "Today's Covid-19 Status for #{country}:\n
    Total Number of Cases: #{totalCases}\n
    Active Cases: #{activeCases}\n
    Critical Cases: #{critical}\n
    Recovered Cases: #{recovered}"
  end
end
