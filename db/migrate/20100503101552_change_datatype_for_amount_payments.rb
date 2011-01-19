class ChangeDatatypeForAmountPayments < ActiveRecord::Migration
  def self.up
    change_table :payments  do |t|
      t.change :amount, :float
    end
  end

  def self.down
  end
end
