require 'sidekiq'
require 'sidekiq-scheduler'

class RateWorker
	include Sidekiq::Worker
	include CurrenciesHelper
	
	def perform params=nil 
		saveRateToDB getCurrentRateFromSite
	end
end

