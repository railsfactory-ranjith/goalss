class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table "admins", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,     						:string, :limit => 40
						t.column :firstname,:string,:limit=>50
						t.column :lastname,:string,:limit=>50
						t.column :is_active,:boolean
						t.column  :is_manager,:boolean
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :state,:string
      t.column :password_reset_code,:string
				
						t.timestamps
		  
			end
			 Admin.create!( :login => "admin", :password => "admin123",:password_confirmation => "admin123",:email => "admin@goalflo.com",:firstname => "admin",:lastname  => "admin",:is_active => true,:is_manager => true, :activated_at=>Time.now)
  end

  def self.down
    drop_table "admins"
  end
end
