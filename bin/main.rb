require 'telegram/bot'
require 'net/http'
require 'json'

token = '1396281284:AAGXP51_X96VNnPmE_UZ944EZaN9lJ2Aq28'


def getWeather(city)
  params = {
    :appid => '0028ea367b25a551e7348f7875810282',
    :q => city,
    :units => 'metric'
  }
  uri = URI("https://api.openweathermap.org/data/2.5/weather")
  uri.query = URI.encode_www_form(params)
  json = Net::HTTP.get(uri)
  api_response = JSON.parse(json)

  api_response['main']['temp']
end


Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "How are you, #{message.from.first_name}")
    when '/time'
      bot.api.send_message(chat_id: message.chat.id, text: "Time is #{Time.now}, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Goodbye, #{message.from.first_name}")
    when 'weather/chennai'
      bot.api.send_message(chat_id: message.chat.id, text: "Weather in New York is, #{getWeather('chennai')} C")
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'I couldn\'t understand that command, please write a valid command.')
    end
  end
end
