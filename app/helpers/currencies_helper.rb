require 'net/http'
require 'uri'
require 'json'

module CurrenciesHelper 

	def	getCurrentRateFromSite valute = 'USD'
		url = 'https://www.cbr-xml-daily.ru/daily_json.js'
		response = Net::HTTP.get_response(URI.parse(url))
		if response.nil?
			return nil
		end
		json = JSON.parse(response.body)
		json['Valute'][valute]['Value']
	end

	def saveRateToDB rValue, valute='USD'
		rate = Currency.new
		rate.value = rValue
		if rate.nil?
			return nil
		end
		rate.save!
	end
end
