class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :group_id
      t.integer :user_id
						t.text :content
      t.boolean :is_group_log
      t.integer :receiver_id
      t.integer :objective_id
			t.boolean :is_by_leader
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
