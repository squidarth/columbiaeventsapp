class DropCommentsAndTags < ActiveRecord::Migration
  def self.up
    drop_table :comments
    drop_table :tags
  end

  def self.down
    create_table :tags do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
    create_table :comments do |t|
      t.string :author
      t.string :content

      t.timestamps
    end
  end
end
