class AddLeaderUpdateReadToUserPosts < ActiveRecord::Migration
  def self.up
    add_column :user_posts, :leader_update_read, :boolean, :default=>true
  end

  def self.down
    remove_column :user_posts, :leader_update_read
  end
end
