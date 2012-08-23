class AddIndicesForOptimization < ActiveRecord::Migration
  def up
    add_index :attendings, :user_id
    add_index :attendings, :event_id
    add_index :authorizations, :user_id
    add_index :categorizations, :event_id
    add_index :events, :start_time
    add_index :events, :facebook_id
    add_index :users, :facebook_id
  end

  def down
    remove_index :users, :facebook_id
    remove_index :events, :facebook_id
    remove_index :events, :start_time
    remove_index :categorizations, :event_id
    remove_index :authorizations, :user_id
    remove_index :attendings, :event_id
    remove_index :attendings, :user_id
  end
end
