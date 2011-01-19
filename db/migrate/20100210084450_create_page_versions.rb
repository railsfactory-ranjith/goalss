class CreatePageVersions < ActiveRecord::Migration
  def self.up
    create_table :page_versions do |t|
      t.integer :page_id
      t.string :title, :limit=>100
      t.text :content
      t.string :meta_keywords, :limit=>40
      t.text :meta_description
      t.timestamps
    end
  end

  def self.down
    drop_table :page_versions
  end
end
