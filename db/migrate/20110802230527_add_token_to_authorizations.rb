class AddTokenToAuthorizations < ActiveRecord::Migration
  def self.up
    add_column :authorizations, :token, :string
  end

  def self.down
    remove_column :authorizations, :token
  end
end
