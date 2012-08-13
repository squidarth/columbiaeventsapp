class Attending < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :status, inclusion: { in: %w(Yes Maybe No) }
  
  acts_as_api
  api_accessible :public do |t|
    t.add :user
    t.add :status
  end
end
