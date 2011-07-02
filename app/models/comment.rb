class Comment < ActiveRecord::Base
  attr_accessible :author, :content, :event_id
  
  belongs_to :event
  
  validates :author, :presence => true, :length => { :maximum => 140 }
  validates :content, :presence => true
  
end
