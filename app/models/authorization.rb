class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider
  
  
  def self.find_from_hash(hash)
    Authorization.find_by_uid(hash['uid'])
  end
  
  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Authorization.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
  end

end
