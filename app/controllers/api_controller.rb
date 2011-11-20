class ApiController < ApplicationController
	def	events 
		@events = Event.getTopEvents()

		respond_to do |format|
			format.html
			format.json
		end 
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
