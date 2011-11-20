class AddFreeFoodToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :freeFood, :boolean
  end

  def self.down
    remove_column :events, :freeFood
  end
end
