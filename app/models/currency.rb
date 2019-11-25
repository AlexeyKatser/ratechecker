require 'sidekiq'
class Currency < ApplicationRecord

	include CurrenciesHelper

	validates :value, presence: true
	validates :value, numericality: { greater_than: 0, less_than: 10000} 
	validate :dateMustBeInFutureOrNil

	after_save :cbroadcast 

	def dateMustBeInFutureOrNil
		unless date.nil?
		 	errors.add(:date, "experation can't be in the past") if date < DateTime.now
		end
	end

  private

	def cbroadcast
		broadcast
	end
end
