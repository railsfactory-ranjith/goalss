class CreateBetaInvits < ActiveRecord::Migration
  def self.up
    create_table :beta_invits do |t|
        t.string :email,        :limit=>100
      t.string :first_name,  :limit=>50
      t.string :last_name, :limit=>50
      t.string :organization, :limit=>50
      t.string :occupation, :limit=>50
      t.string :country, :limit=>50
      t.integer :demographic_id
      t.string :zipcode, :limit=>20
      t.date :dob
      t.string :referred_by,  :limit=>50
      t.text :invitation_msg
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_invits
  end
end
