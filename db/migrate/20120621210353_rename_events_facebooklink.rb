class RenameEventsFacebooklink < ActiveRecord::Migration
  def up
    rename_column :events, :facebooklink, :facebook_id
    remove_column :events, :facebookevent
  end

  def down
    rename_column :events, :facebook_id, :facebooklink
    add_column :events, :facebookevent, :integer
  end
end
