class AddConfirmedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmed, :boolean
  end

  def self.down
    remove_column :users, :confirmed
  end
end
