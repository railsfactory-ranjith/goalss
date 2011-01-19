class CreateFbSessions < ActiveRecord::Migration
  def self.up
    create_table :fb_sessions do |t|

      t.string :uid, :limit=>50
      t.string :local_session_id
      t.string :fb_session_key
      t.string :fb_user_token, :limit=>30
      t.string :fb_user_name
      t.timestamps

    end
  end

  def self.down
    drop_table :fb_sessions
  end
end
