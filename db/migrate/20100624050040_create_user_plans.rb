class CreateUserPlans < ActiveRecord::Migration
  def self.up
    create_table :user_plans do |t|
      t.integer :user_id
      t.float :amount
      t.integer :max_users_in_group
      t.integer :max_group
      t.integer :day
      t.timestamps
    end
  end

  def self.down
    drop_table :user_plans
  end
end
