class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :group_id
      t.string :first_name,:limit=>50
      t.string :last_name,:limit=>50
      t.string :email,:limit=>100
						t.string :image_url ,:limit=>255
      t.string :source_site,:limit=>100
      t.text :message
      t.integer :user_id 
      t.integer :invitation_code
      t.datetime :invited_at
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
