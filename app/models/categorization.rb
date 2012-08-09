class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :event

  validates :event_id, :presence => true, :uniqueness => { :scope => :category_id }
  validates :category_id, :presence => true, :uniqueness => { :scope => :event_id }

  delegate :name, to: :category

  acts_as_api
  api_accessible :public do |t|
    t.add :category
  end
end
