class RemoveDayteFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :dayte
  end

  def self.down
    add_column :events, :dayte, :time
  end
end
