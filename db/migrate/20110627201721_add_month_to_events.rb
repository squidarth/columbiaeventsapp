class AddMonthToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :month, :string
  end

  def self.down
    remove_column :events, :month
  end
end
