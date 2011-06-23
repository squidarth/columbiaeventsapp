class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :aboutme
      t.string :affiliatedorgs
      t.string :school
      t.string :fblink

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
