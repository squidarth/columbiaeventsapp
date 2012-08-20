class RenameNumAttendingsForEvents < ActiveRecord::Migration
  def up
    rename_column :events, :numAttending, :attendings_count
  end

  def down
    rename_column :events, :attendings_count, :numAttending
  end
end
