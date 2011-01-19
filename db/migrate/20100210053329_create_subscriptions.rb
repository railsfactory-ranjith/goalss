class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :pricing_plan_id
      t.date :next_renewal_at
      t.date :billing_start_date
      t.date :billing_end_date
      t.integer :coupon_code_id
      t.integer :discount_amount
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
