class AddCategoryToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :category, :integer
  end

  def self.down
    remove_column :events, :category
  end
end
