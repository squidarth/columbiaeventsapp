class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :author
      t.string :facebooklink
      t.string :location

      t.timestamps
    end

    # How did these columns get here?
    add_column :events, :year, :integer
    add_column :events, :month, :integer
    add_column :events, :day, :integer
  end

  def self.down
    remove_column :events, :day
    remove_column :events, :month
    remove_column :events, :year

    drop_table :events
  end
end
