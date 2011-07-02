class AddDayToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :day, :integer
  end

  def self.down
    remove_column :events, :day
  end
end
