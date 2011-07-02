class AddYearToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :year, :integer
  end

  def self.down
    remove_column :events, :year
  end
end
