class CategoriesController < ApplicationController
    def free_food
      @title = "Free Food"
      @events = []
      @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

      Event.all.each do |event|
        if(event.check_for_food)
          @events << event
        end
      end



      @events = filter_and_sort_date(@events)
      @master_array = Event.paginate(@events)

      if params[:page]
         if params[:page].to_i > @master_array.length
            @array_of_events = []
         else
           @array_of_events = @master_array[params[:page].to_i]
         end
      else
        @array_of_events = @master_array[0]
      end

      respond_to do |format|
        format.html
        format.js
      end

    end
    def category
      category = params[:category]
      
      @categories = [' ','Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other', 'Cultural', 'Special Interest', 'Music', 'NYC Events', 'Academics']
      @title = @categories[params[:category].to_i]
      
      
      @events = order_array(params[:category].to_i)
      @master_array = Event.paginate(@events)
      puts "Master array: #{@master_array.to_s}"
      if params[:page]
        if params[:page].to_i > @master_array.length
          @array_of_events = []
        else
          @array_of_events = @master_array[params[:page].to_i]
        end

      else
        @array_of_events = @master_array[0]
      end

      
      @times = ['12:00 AM', '1:00 AM','2:00 AM', '3:00 AM','4:00 AM','5:00 AM', '6:00 AM','7:00 AM','8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM']
      @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    
      respond_to do |format|
        format.html
        format.js
      end

    end
       private
   
    def compile_categories(category)

      categories = [' ','Fraternities', 'Theater', 'Sports', 'Politics', 'Career Networking', 'Arts', 'Community Service', 'Student Council', 'Other', 'Cultural', 'Special Interest', 'Music', 'NYC Events', 'Academics']

      array_of_events = []
        Event.all.each do |event|
          if event.category == category
            array_of_events << event
            added = true
          end
          if(!added)
            event.tags.each do |tag|
              if(tag.name == categories[category])
                array_of_events << event    
              end
            end
          end
       end
      events = filter_and_sort_date(array_of_events)
      events
    end
    
    def order_array(category)
       array_to_be_sorted = compile_categories(category)
       array_to_be_sorted
    end
    
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
          if event.date
             other_events << event
          end
        end
        other_events.sort! {|a,b| b.date <=> a.date}
        filtered_events += other_events
        temp_events.each do |event|
          if !event.date
            filtered_events << event
          end
        
        end
        filtered_events
  end

end
