class AddFbnicknameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fbnickname, :string
  end

  def self.down
    remove_column :users, :fbnickname
  end
end
