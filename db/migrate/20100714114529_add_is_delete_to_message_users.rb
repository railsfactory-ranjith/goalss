class AddIsDeleteToMessageUsers < ActiveRecord::Migration
  def self.up
    add_column :message_users, :is_delete, :boolean,:default=>false
  end

  def self.down
    remove_column :message_users, :is_delete
  end
end
