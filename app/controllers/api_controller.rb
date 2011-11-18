class ApiController < ApplicationController
	def	events 
		@events = Event.all 
	end


	private

	def get_top

	end

	def authenticate
		if(!signed_in?)
			return false
		else
			return true
		end

	
	end
end
