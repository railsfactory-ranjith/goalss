class AddColumnTimeToUserProfiles < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :date_format, :string
    add_column :user_profiles, :time_zone, :string
    add_column :user_profiles, :title, :string
  end

  def self.down
    remove_column :user_profiles, :date_format
    remove_column :user_profiles, :time_zone
    remove_column :user_profiles, :title
  end
end
