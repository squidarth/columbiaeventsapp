class Event < ActiveRecord::Base
  attr_accessible :name, :description, :date, :time, :location, :author, :facebooklink, :photo
  
  has_attached_file :photo, :styles => { :small => "150x150>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => ":attachment/:id/:style.:extension", :bucket => "ColumbiaEventsApp"
  
  belongs_to :user
  
  default_scope :order => 'events.created_at DESC'
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 140 }
  validates :location,  :length => { :maximum => 140 }
  validates :date, :length => { :maximum => 140 }
  validates :time, :length => { :maximum => 140 }
  validates :author, :length => { :maximum => 140 }
  validates :user_id, :presence => true

end
