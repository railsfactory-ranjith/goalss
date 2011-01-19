class CreateUserPosts < ActiveRecord::Migration
  def self.up
    create_table :user_posts do |t|
      t.integer :post_id
      t.integer :user_id
      t.boolean :is_read, :default=>0
      t.timestamps

    end
  end

  def self.down
    drop_table :user_posts
  end
end
