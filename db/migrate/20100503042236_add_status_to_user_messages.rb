class AddStatusToUserMessages < ActiveRecord::Migration
  def self.up
    add_column :message_users, :status, :string,:limit=>10
  end

  def self.down
    remove_column :message_users,:status
  end
end
