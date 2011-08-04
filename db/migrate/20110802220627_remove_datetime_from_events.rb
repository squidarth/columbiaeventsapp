class RemoveDatetimeFromEvents < ActiveRecord::Migration
  def self.up
    remove_column :events, :datetime
  end

  def self.down
    add_column :events, :datetime, :datetime
  end
end
