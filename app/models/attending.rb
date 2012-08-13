class Attending < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :status, inclusion: { in: %w(YES MAYBE NO) }
  
  acts_as_api
  api_accessible :public do |t|
    t.add :user
    t.add :status
  end
  api_accessible :events do |t|
    t.add :event, template: :public
    t.add :status
  end
end
