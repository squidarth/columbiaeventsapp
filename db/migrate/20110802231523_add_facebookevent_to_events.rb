class AddFacebookeventToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :facebookevent, :integer
  end

  def self.down
    remove_column :events, :facebookevent
  end
end
