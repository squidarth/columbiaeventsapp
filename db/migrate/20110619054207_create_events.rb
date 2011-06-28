class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :date
      t.string :author
      t.string :facebooklink
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
