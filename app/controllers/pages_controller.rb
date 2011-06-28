class PagesController < ApplicationController
  def home
    @title = "Home"
    @users = User.all
    @array_of_events = []
    @users.each do |user|
      events = user.events
      events.each do |event|
        @array_of_events << event
      end
    end
    @array_of_events.shuffle
    
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
