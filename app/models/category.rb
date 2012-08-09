class Category < ActiveRecord::Base
  has_many :categorizations, :dependent => :destroy
  has_many :events, :through => :categorizations

  validates :name, :presence => true, :uniqueness => true

  default_scope order: 'name ASC'

  acts_as_api
  api_accessible :public do |t|
    t.add :id
    t.add :name
  end

  def to_param
    "#{name.parameterize}"
  end
end
