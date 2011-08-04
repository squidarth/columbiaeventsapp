class AddFacebookIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebookid, :string
  end

  def self.down
    remove_column :users, :facebookid
  end
end
