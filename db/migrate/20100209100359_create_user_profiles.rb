class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :first_name,  :limit=>50
      t.string :last_name, :limit=>50
      t.string :organization, :limit=>50
      t.string :occupation, :limit=>50
      t.string :office_email_address, :limit=>100
      t.string :personal_email_address, :limit=>100
      t.string :mobile_phone, :limit=>20
      t.string :office_phone, :limit=>20
      t.string :yahoo_id, :limit=>50
      t.string :windows_live_id, :limit=>50
      t.string :aim_id, :limit=>50
      t.string :skype_id, :limit=>50

      t.string :mailing_address1, :limit=>100
      t.string :mailing_address2, :limit=>100
      t.string :city, :limit=>50
      t.string :state, :limit=>50
      t.string :country, :limit=>50
      t.string :zipcode, :limit=>20
      t.integer :demographic_id
      t.integer :industry_id
      t.string :gender, :limit=>1
      t.date :dob
      t.text :other_info
      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
