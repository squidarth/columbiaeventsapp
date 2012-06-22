class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :events, :through => :categorizations

  validates :name, :presence => true, :uniqueness => true

  default_scope order: 'name ASC'
end
