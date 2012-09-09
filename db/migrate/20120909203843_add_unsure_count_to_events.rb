class AddUnsureCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :unsure_count, :integer
  end
end
