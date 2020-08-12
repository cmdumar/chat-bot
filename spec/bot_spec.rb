require_relative '../lib/bot.rb'
require 'net/http'
require 'json'

describe 'TelegramBot' do
  context '#getWeather' do
    it 'when a valid argument (city) is passed' do
      weather = Bot.new
      expect(weather.send(:getWeather, 'london')).to be_a_kind_of(Hash)
    end
    it 'when a invalid argument is passed' do
      weather = Bot.new
      expect(weather.send(:getWeather, 'iguana')).to be false
    end
  end

  context '#covidCases' do
    it 'when a valid argument (country) is passed' do
      covid = Bot.new
      expect(covid.send(:covidCases, 'india')).to be_a_kind_of(Hash)
    end
    it 'when a invalid argument is passed' do
      covid = Bot.new
      expect(covid.send(:covidCases, 'london')).to be false
    end
  end
end
