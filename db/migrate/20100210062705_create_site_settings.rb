class CreateSiteSettings < ActiveRecord::Migration
  def self.up
    create_table :site_settings do |t|
      t.string :title,:limit=>100
      t.text :description
      t.string :admin_email,:limit=>100
      t.integer :max_free_groups
      t.integer :days_of_free_use
      t.integer :grace_period_payment_hours
      t.timestamps
    end
  end

  def self.down
    drop_table :site_settings
  end
end
