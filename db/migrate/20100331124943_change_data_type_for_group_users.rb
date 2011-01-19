class ChangeDataTypeForGroupUsers < ActiveRecord::Migration
  def self.up
    change_table :group_users do |t|
      t.change :is_active, :boolean,:default=>1
      t.change :is_deleted, :boolean,:default=>0
    end
  end

  def self.down
  end
end
