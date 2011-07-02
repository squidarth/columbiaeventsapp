class PagesController < ApplicationController
  def home
    @title = "Home"
    @users = User.all
    @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
    @categories = ['Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council']
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
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
