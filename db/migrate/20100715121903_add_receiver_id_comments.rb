class AddReceiverIdComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :receiver_id, :integer
  end

  def self.down
    remove_column :comments, :receiver_id
  end
end
