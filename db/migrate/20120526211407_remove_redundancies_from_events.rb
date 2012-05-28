class RemoveRedundanciesFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :day
    remove_column :events, :month
    remove_column :events, :year
    remove_column :events, :freeFood
    remove_column :events, :datescore
  end

  def self.down
    add_column :events, :datescore, :boolean
    add_column :events, :freeFood, :boolean
    add_column :events, :year, :integer
    add_column :events, :month, :integer
    add_column :events, :day, :integer
  end
end
