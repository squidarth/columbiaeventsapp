class PagesController < ApplicationController
  def home
    @title = "Home"
    @users = User.all
    @array_of_events = filter_and_sort_date(Event.all)
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  private
  
      def filter_and_sort_date(events)
        temp_events = events
        filtered_events = []
        temp_events.each do |event|
          if event.date
            if event.date >= Date.today
              filtered_events << event  
              temp_events.delete(event)
            end
          end
        end
        filtered_events.sort! {|a,b| a.date <=> b.date}
        
        other_events = []
        temp_events.each do |event|
          if event.date && event.date > (Date.today - 20)
             other_events << event
          end
        end
        other_events.sort! {|a,b| b.date <=> a.date}
        filtered_events += other_events
        filtered_events
  end
end
