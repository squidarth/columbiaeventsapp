class AddStatusToAttending < ActiveRecord::Migration
  def change
    add_column :attendings, :status, :string
  end
end
