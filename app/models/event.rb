class Event < ActiveRecord::Base
  #attr_accessible :name, :description, :day, :time, :location, :author, :facebooklink, :photo, :year,:date, :month, :category, :datescore
  
  has_attached_file :photo, :styles => { :thumb => "75x75>", :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  has_many :comments, :dependent => :destroy
  
  belongs_to :user
  
  default_scope :order => 'events.created_at DESC'
  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 140 }
  validates :location,  :length => { :maximum => 140 }
  validates :author, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  validate :validate_date
  
  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    find(:all, :conditions => ['LOWER(name) LIKE ? OR LOWER(description) LIKE ? ', search_condition, search_condition])
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
  private
  
    def validate_date
      if self.date
      errors.add("Date", "is invalid.") unless self.date > Date.today || self.date == Date.today
      end
    end
    
    
end
