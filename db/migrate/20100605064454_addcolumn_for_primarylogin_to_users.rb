class AddcolumnForPrimaryloginToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :primary_email, :string
    add_column :users, :primary_activiation_code, :string
    end

  def self.down
    remove_column :users, :primary_email
    remove_column :users, :primary_activation_code
  end
end
