class RemovePasswordFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :encrypted_password
  end

  def down
    add_column :users, :encrypted_password, :string
  end
end
