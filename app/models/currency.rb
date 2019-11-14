class Currency < ApplicationRecord

	validates :value, presence: true
	validates :value, numericality: { greater_than: 0, less_than: 10000} 

	after_save :broadcast 

    private
	    def broadcast 
	    	ActionCable.server.broadcast('rate_notifications_channel', rvalue: "<h2 class='text-center'>#{self.value}</h2>" )
	    end 
end
