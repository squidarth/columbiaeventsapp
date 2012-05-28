class AddEventsToCategorization < ActiveRecord::Migration
  def self.up
    add_column :categorizations, :event_id, :integer
  end

  def self.down
    remove_column :categorizations, :event_id
  end
end
