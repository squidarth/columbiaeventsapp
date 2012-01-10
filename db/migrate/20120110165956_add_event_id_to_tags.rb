class AddEventIdToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :event_id, :integer
  end

  def self.down
    remove_column :tags, :event_id
  end
end
