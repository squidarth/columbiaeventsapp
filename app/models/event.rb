class Event < ActiveRecord::Base
  #attr_accessible :name, :description, :day, :time, :location, :author, :facebooklink, :photo, :year,:date, :month, :category, :datescore
  
  has_attached_file :photo, :styles => { :thumb => "75x75>", :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  has_many :comments, :dependent => :destroy
  has_many :attendings, :dependent => :destroy
  
  belongs_to :user
  
  default_scope :order => 'events.created_at DESC'
  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :location,  :length => { :maximum => 140 }
  validates :author, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  validate :validate_date
  

  def self.strip_events(user_id)
    
    User.all.each do |user|
      if(user.id >= 39)
        if(user.fbnickname || user.facebookid)
          token = user.authorizations.find_by_provider('facebook').token
			Event.get_events(token)
			puts "hi"
		end
      end
    end
  end
  
  def self.make_from_facebook(event_id, author, category)
      event_ids = []
      Event.all.each do |event|
        if event.facebooklink
          event_ids << event.facebooklink
        end
      end
      if(!event_ids.include?(event_id))
        @me = User.find(45) #find the EventSalsa user
        @graph = Koala::Facebook::GraphAPI.new(@me.authorizations.find_by_provider("facebook").token)
        @event_deets = @graph.get_object(event_id)
        @time_to_change = Time.parse(@event_deets["start_time"])
        #figure out how to change timezones
        @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)-8), @time_to_change.min) #this hack used to offset time differences
        @date = Date.parse(@event_deets["start_time"])
        create!(:user_id => User.find(44).id, :facebooklink => event_id, :name => @event_deets["name"], :description => @event_deets["description"].to_s, :author => author, :location => @event_deets[:location], :time => @time, :date => @date, :category => category)
      end
  end
  
  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    find(:all, :conditions => ['LOWER(name) LIKE ? OR LOWER(description) LIKE ? ', search_condition, search_condition])
  end
  
  def self.get_fb_attendings(id)
    @me = User.find(45)
    @token = @me.authorizations.find_by_provider('facebook').token
    @graph = Koala::Facebook::GraphAPI.new(@token)
    @people = @graph.get_connections(id.to_s, 'attending')
    return @people
  end
  
  def self.get_fb_maybes(id)
    @me = User.find(45)
    @token = @me.authorizations.find_by_provider('facebook').token
    @graph = Koala::Facebook::GraphAPI.new(@token)
    @people = @graph.get_connections(id, 'maybe')
    return @people    
  end
  def self.find_by_date(date)
    @events = Event.all
    @sorted_events = []
    @events.each do |event|
      if event.date == date
        sorted_events << event
      end
    end
  end
  
  def self.test(id)
    @me = User.find(45)
    @token = @me.authorizations.find_by_provider('facebook').token
    @graph = Koala::Facebook::GraphAPI.new(@token)
    
    event = @graph.get_object(id)
    event
  end
  
  def self.check_token_valid(user)
    	@token = user.authorizations.find_by_provider('facebook').token
		
		begin
			@graph = Koala::Facebook::GraphAPI.new(token)
		rescue 
			return nil
		ensure
	    	return nil
		end
  end
  def self.get_events(token)
    
  	@graph = Koala::Facebook::GraphAPI.new(token)
	events = @graph.get_connections('me', 'events')
    event_ids = []
    Event.all.each do |event|
      if(event.facebooklink)
        event_ids << event.facebooklink
      end
    end
    events.each do |event|
      the_event = @graph.get_object(event['id'])
      if(!event_ids.include?(the_event['id']) && the_event["privacy"].eql?("OPEN"))
      @time_to_change = Time.parse(the_event["start_time"])
      @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)), @time_to_change.min) #this hack used to offset time differences
      @time = @time-28800
	  @numAttending = Event.get_fb_attendings(event['id'])
      @date = Date.parse(the_event["start_time"])
       if create(:numAttending => @numAttending, :user_id => @me.id, :facebooklink => the_event['id'], :name => the_event['name'], :author => '', :description => the_event["description"].to_s, :location => the_event['location'], :time => @time, :date => @date, :category => 9)
       else
       end
     end
    end
  end
 
	def self.update_attendings()
		Event.all.each do |event|
			if(event.facebooklink)
				@attendings = Event.get_fb_attendings(event.facebooklink)
				numAttending = 0

				@attendings.each do |attending|
					numAttending+=1

				end
				event.numAttending =numAttending
				event.save
			end
		end
	end

	def self.getTopEvents()
		@events = Event.all
		@filtered_events = []
		@returned_events = []
		
		@events.each do |event|
		
			if(event.date && (event.date >= Date.today && event.date < (Date.today + 30)) && !event.deleted)	
					@filtered_events << event
			end
		end
	
		@filtered_events.sort! {|a,b| b.numAttending <=> a.numAttending}
	
		
        new_array = []

        p = 0.85  #constant


        while new_array.size < 10
          @filtered_events.each do |event|
              num = rand.unif(0,1)

              if num < p
                new_array << event
              end
              if new_array.size > 10
                break
              end
          end
        end 
        #Check to make sure that new_array has at least 10 elements. If not, repeat the iteration
        
       
		return new_array
	end


 
  private
  
    def validate_date
      if !self.facebooklink
        if self.date
        errors.add("Date", "is invalid.") unless self.date > Date.today || self.date == Date.today
        end
      end
    end
    
end    
