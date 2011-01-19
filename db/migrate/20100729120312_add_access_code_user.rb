class AddAccessCodeUser < ActiveRecord::Migration
  def self.up
    add_column :users, :access_code, :string
  end

  def self.down
    remove_column :users, :access_code
  end
end
