class ApiController < ApplicationController
	def	events 
		@events = Event.getTopEvents()
		render :json => @events
	end


    def emails
      @emails = []
      User.all.each do |user|
        if user.email
          @emails << user.email
        end

      end

      if signed_in?
        render :json => @emails
      else
        render :json => []
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
