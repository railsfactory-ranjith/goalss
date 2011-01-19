class ChangeDataTypeForAmount < ActiveRecord::Migration
  def self.up
    change_table :pricing_plans  do |t|
      t.change :amount, :float
    end
  end
  def self.down
  end
end
