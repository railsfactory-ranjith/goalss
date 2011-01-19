class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :user_name,                     :string,:limit=>50
      t.column :email,                     :string,:limit=>100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string,:limit=>40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
						
						
						t.string :password_reset_code						
						t.string :state
						t.datetime :deleted_at
						t.string :openid_url
						t.boolean :is_rpx
						t.string :signup_type,:limit=>50
						t.string :identifier_url,:limit=>200
						t.boolean :is_free_user
						t.integer :pricing_plan_id
						t.string :reason_for_delete,:limit=>100
						t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
