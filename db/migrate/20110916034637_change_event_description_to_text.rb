class ChangeEventDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column(:events, :description, :text)
  end

  def self.down
       remove_column :events, :description
  end
end
