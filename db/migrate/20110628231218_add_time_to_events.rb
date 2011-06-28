class AddTimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :time, :integer
  end

  def self.down
    remove_column :events, :time
  end
end
