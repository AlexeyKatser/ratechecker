require 'sidekiq'
require 'sidekiq-scheduler'

class AdminWorker
	include Sidekiq::Worker
	include CurrenciesHelper
	
	def perform params=nil 
		p 'admin worker time:'
		broadcast
	end	
end