class ChangePhoneDatatypeUserProfiles < ActiveRecord::Migration
  def self.up
    change_table :user_profiles do |t|
      t.change :mobile_phone, :string, :limit=>40
      t.change :office_phone, :string, :limit=>40
    end
  end

  def self.down
  end
end
