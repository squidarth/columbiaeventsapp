class Group < ActiveRecord::Base
  attr_accessible :name, :description, :facebook_id, :photo

  has_many :memberships
  has_many :users, through: :memberships

  has_attached_file :photo, styles: { thumb: "75x75>", small: "150x150>" }, storage: :s3, s3_credentials: "#{Rails.root}/config/s3.yml", path: ":attachment/:id/:style.:extension", bucket: "ColumbiaEventsApp"
  validates_attachment_size :photo, less_than: 5.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/gif']

  acts_as_api
  api_accessible :public do |t|
    t.add :name
    t.add :description
    t.add :facebook_id
  end
end
