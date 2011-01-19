class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
					t.integer :group_id
					t.integer :user_id
					t.string :color_code,:limit=>10
					t.datetime :is_active
					t.datetime :is_deleted
					t.boolean :Last_Mark_As_Read
					t.timestamps
    end
  end

  def self.down
    drop_table :group_users
  end
end
