class CreateUserSettings < ActiveRecord::Migration
  def self.up
    create_table :user_settings do |t|
      t.integer :user_id
      t.boolean :organization
      t.boolean :occupation
      t.boolean :office_email_address
      t.boolean :personal_email_address
      t.boolean :mobile_phone
      t.boolean :ofice_phone
      t.boolean :yahoo_id
      t.boolean :windows_live_id
      t.boolean :AIM_id
      t.boolean :skype_id
      t.boolean :mailing_address1
      t.boolean :mailing_address2
      t.boolean :city
      t.boolean :state
      t.boolean :zip
      t.boolean :country
      t.timestamps
    end
  end

  def self.down
    drop_table :user_settings
  end
end
