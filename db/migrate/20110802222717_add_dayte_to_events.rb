class AddDayteToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :dayte, :time
  end

  def self.down
    remove_column :events, :dayte
  end
end
