class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.integer :pricing_plan_id
      t.integer :subscription_id
      t.integer :amount
      t.string :transaction_id, :limit=>100
      t.string :transcation_type, :limit=>100
      t.integer :card_4digit
      t.integer :exp_month
      t.integer :exp_year
      t.datetime :start_date
      t.datetime :end_date
      t.string :gateway_response, :limit=>100
      t.text :description
      t.boolean :is_success
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
