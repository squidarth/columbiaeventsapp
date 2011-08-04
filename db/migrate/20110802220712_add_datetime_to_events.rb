class AddDatetimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :datetime, :time
  end

  def self.down
    remove_column :events, :datetime
  end
end
