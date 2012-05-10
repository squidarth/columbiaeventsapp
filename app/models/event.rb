class Event < ActiveRecord::Base
  attr_accessible :name, :description, :day, :time, :location, :author, :facebooklink, :photo, :year,:date, :month, :category, :datescore
  
  has_attached_file :photo, :styles => { :thumb => "75x75>", :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  has_many :comments, :dependent => :destroy
  has_many :attendings, :dependent => :destroy
  has_many :tags, :dependent => :destroy

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
        if((user.fbnickname || user.facebookid) && user.check_token_valid)
          token = user.authorizations.find_by_provider('facebook').token
			    Event.get_events(token)
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
        @graph = Koala::Facebook::API.new(@me.authorizations.find_by_provider("facebook").token)
        @event_deets = @graph.get_object(event_id)
        @time_to_change = Time.parse(@event_deets["start_time"])
        #figure out how to change timezones
        @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)-8), @time_to_change.min) #this hack used to offset time differences
        @date = Date.parse(@event_deets["start_time"])
        event = create!(:user_id => User.find(44).id, :facebooklink => event_id, :name => @event_deets["name"], :description => @event_deets["description"].to_s, :author => author, :location => @event_deets[:location], :time => @time, :date => @date, :category => category)
        event.segregate_by_category
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
    puts id.to_s
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
  

  def self.check_if_user(id, token)
    @graph = Koala::Facebook::GraphAPI.new(token)
    attendings = @graph.get_connections(id.to_s, 'attending')
    user_count = 0
    attendings.each do |attending|
      user = User.find_by_name(attending["name"])
      if(user)
        user_count = user_count +1
      end
    end
  
    if(user_count > 1)
     return true
    else
      return false
    end
  end

  def self.get_events(token)
  	@graph = Koala::Facebook::API.new(token)
	  events = @graph.get_connections('me', 'events')
    event_ids = []
    Event.all.each do |event|
      if(event.facebooklink)
        event_ids << event.facebooklink
      end
    end
    events = events.sample(10)
    events.each do |event|
      begin
        the_event = @graph.get_object(event['id'])
        if(the_event && Event.check_if_user(event['id'], token) && !event_ids.include?(the_event['id']) && the_event["privacy"].eql?("OPEN"))
          @time_to_change = Time.parse(the_event["start_time"])
          @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)), @time_to_change.min) #this hack used to offset time differences
          @time = @time-28800
	        @numAttending = Event.get_fb_attendings(event['id'])
          @date = Date.parse(the_event["start_time"])
       
            if new_event = create(:numAttending => @numAttending, :user_id => 44, :facebooklink => the_event['id'], :name => the_event['name'], :author => '', :description => the_event["description"].to_s, :location => the_event['location'], :time => @time, :date => @date)
              new_event.segregate_by_category
            else
            end
        end
     rescue Koala::Facebook::APIError
        puts "found error"
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
		
			if(event.date && (event.date >= Date.today && event.date < (Date.today + 30)) && !event.deleted && event.numAttending)	
					@filtered_events << event
			end
		end
	
		@filtered_events.sort! {|a,b| b.numAttending <=> a.numAttending}
        new_array = []
        p = 0.85  #constant
        while new_array.size < 10
          @filtered_events.each do |event|
              num = rand

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

    def check_for_food
      description = self.description.downcase
      if description.include? "free food"
        return true
      else 
        return false
      end
    end

    def segregate_by_category
      glife = ["pike", "sigep", "frat", "fraternity", "greek life", "sorority", "sigma kai","sigma nu"]
      check_category(glife, "Fraternities")
      #Sports array
      sports = ["sports", "football", "rowing", "basketball", "swimming", "volleyball", "fencing", "archery", "lacrosse", "golf", "cross country","soccer", "skiing", "ski", "softball", "baseball", "wrestling", "tennis", "track", "compete", "dartmouth", ]
      check_category(sports, "Sports")
      #Theater array
      theater = ["theater", "miller", "shakespeare", "oedipus", "perform"]
      check_category(theater, "Theater")
      #Arts Array
      arts = []
      check_category(arts, "Arts")
      #Cultural Array
      cultural = ["cultural", "chinese", "taiwanese", "muslim", "indian", "pakistani", "indonesian", "asian", "korean", "mexican", "african", "bso", "zamana"]
      check_category(cultural, "Cultural")
      #Special Interest
      spec_interest = ["adi", "mun"]
      check_category(spec_interest, "Special Interest")
      #Career Networking
      careers = ["cce", "career", "law", "banking", "medicine", "premed", "pre-med", "pre-law", "prelaw","cce", "application", "goldman", "mckinsey", "jp morgan", "merill lynch", "ubs"]
      check_category(careers, "Career Networking")
      #Politics
      politics = ["politics", "activism", "democrats", "republicans", "debate", "mitt romney", "george bush", "obama"]
      check_category(politics, "Politics")
      #Community Service
      service = ["giving", "service","charity", "outreach"]
      check_category(service, "Community Service")
      #Student Council
      stuco = ["student council", "ccsc", "esc"]
      check_category(stuco, "Student Council")
      #NYC Events
      nyc = []
      check_category(nyc, "NYC Events")
    end

    def check_category(array, tagname)
      array.each do |keyword|
        if(self.description.downcase.include? keyword)
          Tag.create(:event_id => self.id, :name => tagname)
          return true
        end
      end
      return false
    end

    def check_friends(user)
     if(user.fblink || user.fbnickname) 
        @me = User.find(45)
        @token = @me.authorizations.find_by_provider('facebook').token
        @graph = Koala::Facebook::GraphAPI.new(@token)
        @attendees = @graph.get_connections(self.facebooklink, 'attending')
        

        @current_graph = Koala::Facebook::GraphAPI.new(user.authorizations.find_by_provider('facebook').token)
        @friends = @current_graph.get_connections("me", "friends")
        #return all the people who are both attendees and friends
      
        @attendees_names = @attendees.collect{|f| f["name"]}
        @friends_names = @friends.collect {|f| f["name"]}
     
        @friends_and_attendees = @friends_names & @attendees_names
        return @friends_and_attendees
     else 
      return []
     end
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
