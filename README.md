# Telegram Bot

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/mohammadumar28/chat-bot/Tests?label=RSpec)  ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/mohammadumar28/chat-bot/Linters?label=RuboCop)

A Telegram Bot built using Ruby. Get statistics and updates about Covid-19 for any country and the latest weather forecast for cities worldwide.

![screenshot](./assets/screenshot.png)

## Before Running The Project

If you want to run the project locally in your machine, then you need to obtain the API keys to run it, otherwise it will throw an error.

### 1. Telegram Bot Token

* You can get the Telegram Bot Token from [BotFather](https://core.telegram.org/bots#6-botfather).

### 2. OpenWeather API

* Go to [OpenWeather Website](https://openweathermap.org/)
* Sign up and go to this [page](https://home.openweathermap.org/api_keys)
* Copy the API key

## Run the Project Locally

* Clone the Repo `git clone https://github.com/mohammadumar28/chat-bot.git`
* Run `cd chat-bot` to change directory to the cloned repo.
* In the cloned repo directory, create a `.env` file
* Create 2 variables like this:

```
TELEGRAM_TOKEN=<Replace with Telegram Bot Token>
OPENWEATHER_API=<Replace with OpenWeather API key>
```
* Run `bundle install`.
* Run `ruby bin/main.rb` to start the bot.
* Open the bot in a [Telegram app](https://telegram.org/apps) using this [link](https://t.me/chingani_bot)

## Note:

The bot has been already deployed and running on Heroku, So running the project locally might throw an error because **only 1** instance of the bot can run at a time.

## Bot Features/Commands

1. `/start` - Welcome Message.
2. `covid/<country-name>` - Current Covid-19 stats for a country.
3. `weather/<city-name>` - Latest Weather forecast for a city.
4. `/date` - today's date.
5. `/help` - List of all the commands and examples.

## Tools/Languages Used

* Ruby
* RSpec
* Heroku

## Author

**Muhammad Umar**
- Github: [@mohammadumar28](https://github.com/mohammadumar28)
- LinkedIn: [Mohammad Umar](https://www.linkedin.com/in/mohammadumar28/)
- Twitter: [@Mohammadumar28](https://twitter.com/Mohammadumar28)
- Telegram: [@mohammadumar28](https://t.me/mohammadumar28)
- Email: [mohammadumar28@gmail.com](mailto:mohammadumar28@gmail.com)

## Acknowledgements

* [Telegram API](https://core.telegram.org/api)
* [Telegram Bot Ruby](https://github.com/atipugin/telegram-bot-ruby)
* [Open Weather API](https://openweathermap.org/)
* [Novel Covid API](https://github.com/NovelCOVID/API)

## Contribution

* Fork this repo.
* Create your feature branch `git checkout -b my-new-feature`.
* Commit your changes `git commit -am "Add some feature"`.
* Push to the branch `git push origin my-new-feature`.
* Create a new Pull Request.
