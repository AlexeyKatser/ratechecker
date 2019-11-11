class Currency < ApplicationRecord

	validates :value, presence: true
	validates :value, numericality: { greater_than: 0, less_than: 10000} 

	after_save :broadcast 

	after_save do
		p 'auto_save'
	end

	after_find do
		p 'find!'
	end
		
    private
	    def broadcast 
	    	p 'broadcast'
	    	ActionCable.server.broadcast('rate_notifications_channel', rvalue: "<h2>#{self.value}</h2>" )
	    end 
end
