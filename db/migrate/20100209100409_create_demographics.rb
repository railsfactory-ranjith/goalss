class CreateDemographics < ActiveRecord::Migration
  def self.up
    create_table :demographics do |t|
      t.string :name,:limit=>50
      t.timestamps
    end
  end

  def self.down
    drop_table :demographics
  end
end
