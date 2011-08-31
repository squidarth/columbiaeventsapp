class CreateAttendings < ActiveRecord::Migration
  def self.up
    create_table :attendings do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :attendings
  end
end
