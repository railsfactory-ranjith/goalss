class CreateUserCreditcards < ActiveRecord::Migration
  def self.up
    create_table :user_creditcards do |t|
 t.integer :user_id
					t.integer :last_digit
					t.integer :exp_year
					t.integer :exp_month
					t.string :card_type,:limit=>20
					t.integer :ccv_number
					t.string :recurring_profile_id,:limit=>20

      t.timestamps

    end
  end

  def self.down
    drop_table :user_creditcards
  end
end
