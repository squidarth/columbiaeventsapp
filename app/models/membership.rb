class Membership < ActiveRecord::Base
  attr_accessible :user_id, :group_id, :status

  belongs_to :user
  belongs_to :group

  validates :status, inclusion: { in: %w(moderator follower) } 

  acts_as_api
  api_accessible :public do |t|
    t.add :user_id
    t.add :group_id
    t.add :status
  end
end
