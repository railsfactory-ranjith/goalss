class CreateObjectiveUsers < ActiveRecord::Migration
  def self.up
    create_table :objective_users do |t|
					t.integer :user_id
					t.integer :objective_id
				 t.timestamps
    end
  end

  def self.down
    drop_table :objective_users
  end
end
