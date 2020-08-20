require_relative '../config/environment.rb'
require 'humanize'

module BotData
  def self.get_weather(api_key, city)
    params = {
      appid: api_key,
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
      description: data['weather'][0]['description'],
      humidity: data['main']['humidity'],
      wind: data['wind']['speed'],
      feels_like: data['main']['feels_like']
    }
    info
  end

  def self.covid_cases(country)
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
      recovered: data['recovered'],
      todayCases: data['todayCases'],
      population: data['population'],
      continent: data['continent']
    }
    info
  end

  def self.weather_text(method_name)
    "Weather Now in ___#{method_name[:city]}_\r__

    Temperature: *#{method_name[:temp]} C*

    Feels Like: *#{method_name[:feels_like]} C*

    Weather: *#{method_name[:weather]}*

    Description: *#{method_name[:description]}*

    Humidity: *#{method_name[:humidity]}%*

    Wind Speed: *#{method_name[:wind]} km/h*"
  end

  def self.covid_text(method_name)
    "Covid-19 Statistics for __#{method_name[:country]}__ :

    Population: *#{number_comma(method_name[:population])}* (#{method_name[:population].humanize.capitalize})

    Total Cases: *#{number_comma(method_name[:totalCases])}* (#{method_name[:totalCases].humanize.capitalize})

    Today's Cases: *#{number_comma(method_name[:todayCases])}* (#{method_name[:todayCases].humanize.capitalize})

    Active Cases: *#{number_comma(method_name[:activeCases])}* (#{method_name[:activeCases].humanize.capitalize})

    Critical Cases: *#{number_comma(method_name[:critical])}* (#{method_name[:critical].humanize.capitalize})

    Recovered Cases: *#{number_comma(method_name[:recovered])}* (#{method_name[:recovered].humanize.capitalize})

    Total Deaths: *#{number_comma(method_name[:deaths])}* (#{method_name[:deaths].humanize.capitalize})

    Continent: *#{method_name[:continent]}*"
  end

  def self.number_comma(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(',').reverse
  end

  def self.welcome(name)
    "Hi! *#{name}*,

    I am a Weather and Covid-19 Bot!
    I can give you detailed Covid-19 statistics for any country and latest weather forecast for any city.

    List of commands you can use:

    1. Covid-19 Statistics: `covid/<replace this with country name>`
    2. Weather Forecast: `weather/<replace this with city name>`
    3. Today's Date: /date (To know the date)
    4. Help: /help (To list all the commands)"
  end

  def self.help
    "Is everything alright?
    Oh you want to know the wishes I can grant!
    List of Wishes (Commands) ;):

    1. /start: Welcome Message
    2. `covid/<country-name>`: Covid-19 statistics
    3. `weather/_<city-name>`: Latest Weather Forecast
    4. /date: Today's date
    5. /help: Get the list of all commands.

    Examples:

    How to get Covid-19 statistics for USA?
    Type `covid/usa` to get the statistics for United States Of America

    How to get weather forecast for London?
    Type `weather/london` to get the latest weather for London"
  end

  def self.unknown_command
    "I couldn\'t understand that command, please write a valid command."
  end

  def self.unknown_country
    "Country not found or doesn't have any cases"
  end

  def self.unknown_city
    'City not found, please enter a valid city name.'
  end

  def self.date
    "Today's date is *#{Time.new.day}-#{Time.new.month}-#{Time.new.year}*"
  end

  OPENWEATHER_API = ENV['OPENWEATHER_API']
  TELEGRAM_TOKEN = ENV['TELEGRAM_TOKEN']
end
