require 'sidekiq'
require 'sidekiq-scheduler'

#Sidekiq.configure_client do |config|
##	config.redis = { db: 1}
#end

#Sidekiq.configure_server do |config|
#	config.redis = { db: 1}
#end

class RateWorker
	include Sidekiq::Worker
	include CurrenciesHelper
	
	def perform params=nil 
		saveRateToDB getCurrentRateFromSite
	end
end