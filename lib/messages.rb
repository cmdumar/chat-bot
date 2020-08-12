module Messages
  def self.weather_text(method_name)
    "Weather Now in __#{method_name[:city]}__\n
    Weather: *#{method_name[:weather]}* | Temperature: *#{method_name[:temp]} C*\n
    Humidity: *#{method_name[:humidity]}%* | Wind Speed: *#{method_name[:wind]} km/h*\n"
  end

  def self.covid_text(method_name)
    "Today's Covid-19 Status for __#{method_name[:country]}__:\n
    Total Number of Cases: *#{method_name[:totalCases]}*\n
    Active Cases: *#{method_name[:activeCases]}*\n
    Critical Cases: *#{method_name[:critical]}*\n
    Recovered Cases: *#{method_name[:recovered]}*"
  end

  def self.welcome
    "\nI am a Weather and Covid-19 Bot\n
    You can know about the current weather of any city.\n
    You can know about the Covid-19 Cases and other info of any country.\n
    List of commands you can use in this bot:\n
    Covid-19 command: *covid/*`<replace me with country name>`\n
    Weather command: *weather/*`<replace me with city name>`\n
    Date command: /date (To know the date)"
  end

  def self.help
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
