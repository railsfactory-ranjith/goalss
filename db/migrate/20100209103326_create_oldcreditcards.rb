class CreateOldcreditcards < ActiveRecord::Migration
  def self.up
    create_table :oldcreditcards do |t|
      t.integer :user_id
      t.integer :last_4digit
      t.integer :exp_year
      t.integer :exp_month
      t.string :card_type, :limit=>20
      t.integer :ccv_number
      t.integer :recurring_profile_id
      t.timestamps
    end
  end

  def self.down
    drop_table :oldcreditcards
  end
end
