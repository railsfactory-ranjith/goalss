class CreateAdminLogs < ActiveRecord::Migration
  def self.up
    create_table :admin_logs do |t|
      t.integer :admin_id
      t.integer :user_id
      t.integer :group_id
      t.integer :objective_id
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_logs
  end
end
