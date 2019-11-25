require 'net/http'
require 'uri'
require 'json'
require 'sidekiq'
require 'sidekiq-scheduler'

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

	def getLastValidRate
		rate = Currency.where("added_by = 1 and date > '#{ (DateTime.now + 1.minute).strftime('%Y-%m-%d %H:%M') }'").first
		if rate.nil? 
			rate = Currency.where("added_by is null").last 
		end
		return rate
	end

    def broadcast
		return -1 if (rate = getLastValidRate).nil?
		if rate.added_by == 1		
			Sidekiq.set_schedule('stopAdminRate', { "at" => rate.date.strftime('%Y/%m/%d %H:%M:%S'), class: 'AdminWorker', dynamic: true, queue: 'default' , description: rate.id }) 
			SidekiqScheduler::Scheduler.instance.dynamic = true
			SidekiqScheduler::Scheduler.instance.dynamic_every = '5s'
		end
		ActionCable.server.broadcast('rate_notifications_channel', rvalue: "<h2 class='text-center #{rate.added_by == 1 ? 'text-primary' : 'text-success'}'>#{rate.nil? ? 0 : rate.value} ₽</h2>" ) 
	end 
end
