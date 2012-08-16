class RefactorUsers < ActiveRecord::Migration
  def up
    rename_column :users, :aboutme, :about_me
    rename_column :users, :facebookid, :facebook_id

    remove_column :users, :affiliatedorgs
    remove_column :users, :fblink
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    remove_column :users, :fbnickname
    remove_column :users, :confirmcode
    remove_column :users, :confirmed
  end

  def down
    add_column :users, :confirmed, :boolean
    add_column :users, :confirmcode, :string
    add_column :users, :fbnickname, :string
    add_column :users, :avatar_updated_at, :timestamp
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_name, :string
    add_column :users, :fblink, :string
    add_column :users, :affiliatedorgs, :string

    rename_column :users, :facebookid, :facebook_id
    rename_column :users, :aboutme, :about_me
  end
end
