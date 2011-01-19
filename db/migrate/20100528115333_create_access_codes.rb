class CreateAccessCodes < ActiveRecord::Migration
  def self.up
    create_table :access_codes do |t|
      t.string :access_code,:limit=>50
      t.boolean :is_active
      t.timestamps
    end
  end

  def self.down
    drop_table :access_codes
  end
end
