class AddDatescoreToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :datescore, :float
  end

  def self.down
    remove_column :events, :datescore
  end
end
