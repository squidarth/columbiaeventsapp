class Membership < ActiveRecord::Base
  attr_accessible :user_id, :group_id, :status

  belongs_to :user
  belongs_to :group

  validates :status, inclusion: { in: %w(moderator follower) } 

  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :user
    t.add :group
    t.add :status
  end
  api_accessible :users do |t|
    t.add :id
    t.add :user, template: :public
    t.add :status
  end
  api_accessible :groups do |t|
    t.add :id
    t.add :group, template: :public
    t.add :status
  end
end
