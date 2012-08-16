class RemoveDeprecatedColumnsFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :time
    remove_column :events, :date
    remove_column :events, :category
    remove_column :events, :author
  end

  def down
    add_column :events, :author, :string
    add_column :events, :category, :integer
    add_column :events, :date, :date
    add_column :events, :time, :time
  end
end
