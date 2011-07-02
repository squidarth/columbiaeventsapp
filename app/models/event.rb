class Event < ActiveRecord::Base
  attr_accessible :name, :description, :day, :time, :location, :author, :facebooklink, :photo, :year, :month, :category, :datescore
  
  has_attached_file :photo, :styles => { :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  has_many :comments, :dependent => :destroy
  
  belongs_to :user
  
  default_scope :order => 'events.created_at DESC'
  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 140 }
  validates :location,  :length => { :maximum => 140 }
  validates :date, :length => { :maximum => 140 }
  validates :time, :length => { :maximum => 140 }
  validates :author, :length => { :maximum => 140 }
  validates :user_id, :presence => true

end
