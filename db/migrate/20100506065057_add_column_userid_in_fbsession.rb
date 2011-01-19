class AddColumnUseridInFbsession < ActiveRecord::Migration
  def self.up
      add_column :fb_sessions, :user_id, :integer
  end

  def self.down
      remove_column :fb_sessions, :user_id
  end
end
