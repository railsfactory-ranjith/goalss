class CreateUserNotifications < ActiveRecord::Migration
  def self.up
    create_table :user_notifications do |t|
      t.integer :user_id
      t.boolean :status_update
      t.boolean :objective_update
      t.boolean :new_message
      t.boolean :new_activity_message_thread
      t.boolean :members_info_change
      t.boolean :new_group_member
      t.timestamps
    end
  end

  def self.down
    drop_table :user_notifications
  end
end
