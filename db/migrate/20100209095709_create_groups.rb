class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :limit=>100
      t.text :description
      t.integer :user_id
      t.integer :group_leader_id
			t.datetime :due_date
			t.boolean :is_active
			t.string :leader_email_invite, :limit=>100
			t.string :first_name, :limit=>50
			t.string :last_name, :limit=>50
			t.text :message
			t.datetime :invited_at
			t.integer :invitation_code, :limit=>40
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
