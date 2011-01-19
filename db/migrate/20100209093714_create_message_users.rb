class CreateMessageUsers < ActiveRecord::Migration
  def self.up
    create_table :message_users do |t|
      t.integer :message_id
      t.integer :user_id
      t.boolean :is_read
      t.boolean :is_trash
      t.timestamps
    end
  end

  def self.down
    drop_table :message_users
  end
end
