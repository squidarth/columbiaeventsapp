class Attending < ActiveRecord::Base
  attr_accessible :id, :user_id, :event_id

  belongs_to :user
  belongs_to :event

  validates :status, inclusion: { in: %w(YES MAYBE NO) }
  
  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :user
    t.add :status
  end
  api_accessible :events do |t|
    t.add :id
    t.add :event, template: :public
    t.add :status
  end
end
