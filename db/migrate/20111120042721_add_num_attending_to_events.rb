class AddNumAttendingToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :numAttending, :integer
  end

  def self.down
    remove_column :events, :numAttending
  end
end
