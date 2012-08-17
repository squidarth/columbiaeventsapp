class Event < ActiveRecord::Base
  attr_accessible :name, :description, :facebook_id, :location, :user_id, :start_time

  belongs_to :user
  has_many :attendings, dependent: :destroy
  has_many :attending_users, class_name: 'User', through: :attendings, source: :user
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_attached_file :photo, styles: { thumb: "75x75>", small: "150x150>" }, storage: :s3, s3_credentials: "#{Rails.root}/config/s3.yml", path: ":attachment/:id/:style.:extension", bucket: "ColumbiaEventsApp"
  validates_attachment_size :photo, less_than: 5.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/gif']

  validates :name,        presence: true, length: { maximum: 140 }
  validates :facebook_id, uniqueness: true, allow_nil: true

  default_scope where(deleted: [nil, false])
  scope :none, where('1=0')
  scope :upcoming, lambda { |datetime=DateTime.now| where('start_time > ?', datetime).order('start_time ASC') }
  scope :recent,   lambda { |datetime=DateTime.now| where('start_time < ?', datetime).order('start_time DESC') }
  scope :search,   lambda { |query=''| where('LOWER(name) LIKE ? OR LOWER(description) LIKE ? ', "%#{query.downcase}%", "%#{query.downcase}%") }

  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :name
    t.add :start_time
    t.add :location
    t.add :description
    t.add :facebook_id
    t.add :photo_content_type
    t.add lambda { |event| event.photo.url }, as: :photo_url
    t.add lambda { |event| event.photo.url(:small) }, as: :photo_url_small
    t.add :categorizations
    t.add :attendings
  end

  def self.fetch_all_events_from_facebook
    Authorization.where(provider: 'facebook').each do |authorization|
      authorization.fetch_events_from_facebook
    end
  end

  def fetch_attendings_from_facebook
    authorization = self.user.authorizations.find_by_provider('facebook')
    token = authorization ? authorization.token : ENV['facebook_app_token']
    graph = Koala::Facebook::API.new token
    graph.get_connections(self.facebook_id, 'attending')['data'].each do |attending|
      self.attendings.find_or_create_by_user_id user_id: User.find_by_facebook_id(facebook_id: attending['id']).id, status: attending['rsvp_status']
    end
  end
end
