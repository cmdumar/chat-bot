require_relative '../lib/bot_data.rb'
require 'net/http'
require 'json'
require 'humanize'

describe 'TelegramBot' do
  let(:weather_data) { { city: 'Chennai', weather: 'Thunderstorms', temp: 32, humidity: 60, wind: 4, description: 'Heavy thunderstorm', feels_like: 35 } }
  let(:covid_data) { { country: 'India', totalCases: 1211, activeCases: 111, critical: 11, recovered: 989, population: 1000000000, deaths: 1000, todayCases: 0 } }
  let(:api_key) { BotData::OPENWEATHER_API }
  let(:invalid_key) { '1a2s3v4' }

  describe '#get_weather' do
    it 'when an valid API key is passed' do
      weather_now = BotData.get_weather(api_key, 'Toronto')
      expect(weather_now).to be_a_kind_of(Hash)
    end

    it 'when an invalid API key is passed' do
      weather_now = BotData.get_weather(invalid_key, 'London')
      expect(weather_now).to be false
    end

    it 'when an invalid city name is passed' do
      weather_now = BotData.get_weather(api_key, 'iguana')
      expect(weather_now).to be false
    end
  end

  describe '#covid_cases' do
    it 'when a valid country name is passed' do
      cov_cases = BotData.covid_cases('USA')
      expect(cov_cases).to be_a_kind_of(Hash)
    end

    it 'when an invalid country name is passed' do
      cov_cases = BotData.covid_cases('iguana')
      expect(cov_cases).to be false
    end
  end

  describe '#weather_text' do
    it 'when a valid argument (data) is passed' do
      weather = BotData.weather_text(weather_data)
      expect(weather).to be_a_kind_of(String)
    end
  end

  describe '#covid_text' do
    it 'when a valid argument (data) is passed' do
      covid = BotData.covid_text(covid_data)
      expect(covid).to be_a_kind_of(String)
    end
  end

  describe '#welcome' do
    it 'returns string' do
      welcome = BotData.welcome
      expect(welcome).to be_a_kind_of(String)
    end
  end

  describe '#help' do
    it 'returns string' do
      help = BotData.help
      expect(help).to be_a_kind_of(String)
    end
  end

  describe '#unknown_command' do
    it 'returns string' do
      unknown_command = BotData.unknown_command
      expect(unknown_command).to be_a_kind_of(String)
    end
  end

  describe '#unknown_country' do
    it 'returns string' do
      unknown_country = BotData.unknown_country
      expect(unknown_country).to be_a_kind_of(String)
    end
  end

  describe '#unknown_city' do
    it 'returns string' do
      unknown_city = BotData.unknown_city
      expect(unknown_city).to be_a_kind_of(String)
    end
  end

  describe '#date' do
    it 'returns string' do
      date = BotData.date
      expect(date).to be_a_kind_of(String)
    end
  end
end
