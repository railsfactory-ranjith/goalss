class CreateUserBillingInformations < ActiveRecord::Migration
  def self.up
    create_table :user_billing_informations do |t|
      t.integer :user_id
      t.string :company_name,:limit=>100
      t.string :first_name,:limit=>50
      t.string :last_name,:limit=>50
      t.string :address_1,:limit=>150
      t.string :address_2,:limit=>150
			t.string :city,:limit=>50
      t.string :state,:limit=>50
      t.string :country,:limit=>50
      t.string :zipcode,:limit=>20
      t.string :phonenumber,:limit=>20
      t.string :email_address,:limit=>100
      t.timestamps
    end
  end

  def self.down
    drop_table :user_billing_informations
  end
end
