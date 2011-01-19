class CreateCouponCodes < ActiveRecord::Migration
  def self.up
    create_table :coupon_codes do |t|
      t.string :code
      t.string :coupon_type, :limit=>50
      t.string :value, :limit=>50
      t.date :active_from
      t.date :active_to
      t.boolean :is_active
      t.boolean :is_deleteds
      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_codes
  end
end
