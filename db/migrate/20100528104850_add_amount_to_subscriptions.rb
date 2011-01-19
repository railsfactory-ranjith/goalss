class AddAmountToSubscriptions < ActiveRecord::Migration
  def self.up
    change_table :subscriptions  do |t|
      t.change :discount_amount, :float
    end
    add_column :subscriptions, :card_type, :string,:limit=>20
    add_column :subscriptions, :amount, :float
    add_column :subscriptions, :is_success, :boolean
  end

  def self.down
    remove_column :subscriptions, :card_type
    remove_column :subscriptions, :amount
    remove_column :subscriptions, :is_success
  end
end
