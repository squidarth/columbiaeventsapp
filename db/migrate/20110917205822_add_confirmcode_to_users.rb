class AddConfirmcodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmcode, :string
  end

  def self.down
    remove_column :users, :confirmcode
  end
end
