class CreatePricingPlans < ActiveRecord::Migration
  def self.up
    create_table :pricing_plans do |t|
      t.string :plan_name, :limit=>50
      t.integer :amount
      t.integer :max_users_in_group
      t.integer :max_group
      t.boolean :is_active
      t.timestamps
    end
  end

  def self.down
    drop_table :pricing_plans
  end
end
