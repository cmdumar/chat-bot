require 'net/http'
require 'json'

class Weather
  def initialize
    
  end

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
end