class User < ActiveRecord::Base
  attr_accessible :id, :name, :email, :about_me, :school, :facebook_id
  has_many :events,           :dependent => :nullify
  has_many :authorizations,   :dependent => :destroy
  has_many :attendings,       :dependent => :destroy
  has_many :attending_events, :class_name => 'Event', :through => :attendings, :source => :event

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates :name, :presence => true,
            :length   => { :maximum => 50 }
  validates :email, :presence => true,
            :format   => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
  validates :password, :confirmation => true,
            :length => { :within => 6..40 }

  before_save :encrypt_password

  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :name
  end
  api_accessible :session do |t|
    t.add :id
    t.add :name
    t.add :facebookid
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
end
