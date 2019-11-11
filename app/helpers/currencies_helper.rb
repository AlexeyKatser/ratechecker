require 'net/http'
require 'uri'
require 'json'

module CurrenciesHelper 

	def	getCurrentRateFromSite valute = 'USD'
		url = 'https://www.cbr-xml-daily.ru/daily_json.js'
		response = Net::HTTP.get_response(URI.parse(url))

		json = JSON.parse(response.body)
		json['Valute'][valute]['Value']
	end

	def saveRateToDB valute='USD'
		rate = Currency.new
		rate.value = getCurrentRateFromSite(valute)
		p rate.value
		rate.save!
	end
end
