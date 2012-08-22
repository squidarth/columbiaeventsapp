class User < ActiveRecord::Base
  attr_accessible :id, :name, :email, :about_me, :school, :facebook_id
  has_many :events,           dependent: :nullify
  has_many :authorizations,   dependent: :destroy
  has_many :attendings,       dependent: :destroy
  has_many :attending_events, class_name: 'Event', through: :attendings, source: :event
  
  has_many :memberships
  has_many :groups, through: :memberships

  validates :name, presence: true
  validates :email, presence: true
  validates :facebook_id, presence: true

  before_save :encrypt_password

  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :name
  end
  api_accessible :session do |t|
    t.add :id
    t.add :name
    t.add :facebook_id
  end

  def self.authenticate_with_remember_token(id, facebook_id)
    user = find_by_id_and_facebook_id(id, facebook_id)
  end
end
