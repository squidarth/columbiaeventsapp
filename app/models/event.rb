class Event < ActiveRecord::Base
  #attr_accessible :name, :description, :day, :time, :location, :author, :facebooklink, :photo, :year,:date, :month, :category, :datescore
  
  has_attached_file :photo, :styles => { :thumb => "75x75>", :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  has_many :comments, :dependent => :destroy
  has_many :attendings
  
  belongs_to :user
  
  default_scope :order => 'events.created_at DESC'
  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :location,  :length => { :maximum => 140 }
  validates :author, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  validate :validate_date
  
  def self.make_from_facebook(event_id, author, category)
      @me = User.find(44) #find the EventSalsa user
      @graph = Koala::Facebook::GraphAPI.new
      @event_deets = @graph.get_object(event_id)
      @time_to_change = Time.parse(@event_deets["start_time"])
      #figure out how to change timezones
      @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)-8), @time_to_change.min) #this hack used to offset time differences
      @date = Date.parse(@event_deets["start_time"])
      create!(:user_id => @me.id, :facebooklink => event_id, :name => @event_deets["name"], :description => @event_deets["description"].to_s, :author => author, :location => @event_deets[:location], :time => @time, :date => @date, :category => category)
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
  
  def self.get_events(token)
    @me = User.find(44)
    @token = token
    @graph = Koala::Facebook::GraphAPI.new(@token)
    events = @graph.get_connections('me', 'events')
    event_ids = []
    Event.all.each do |event|
      if(event.facebooklink)
        event_ids << event.facebooklink
      end
    end
    events.each do |event|
      if(!event_ids.include?(event['id']))
      @time_to_change = Time.parse(event["start_time"])
      #figure out how to change timezones
      @time = Time.mktime(2000, 3, 12, ((@time_to_change.hour)-8), @time_to_change.min) #this hack used to offset time differences
      @date = Date.parse(event["start_time"])
     create!(:user_id => @me.id, :facebooklink => event['id'], :name => event['id'], :description => event['description'].to_s, :location => event['location'], :time => @time, :date => @date, :category => 9)
     end
    end
  end
  
  private
  
    def validate_date
      if self.date
      errors.add("Date", "is invalid.") unless self.date > Date.today || self.date == Date.today
      end
    end
    
    
end
