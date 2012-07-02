class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :event

  validates :event_id, :presence => true, :uniqueness => { :scope => :category_id }
  validates :category_id, :presence => true, :uniqueness => { :scope => :event_id }

  delegate :name, to: :category
end
