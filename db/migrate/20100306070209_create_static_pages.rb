class CreateStaticPages < ActiveRecord::Migration
  def self.up
    create_table :static_pages do |t|
      t.string :name
      t.string :title
      t.text :page_center
      t.timestamps

    end
  end

  def self.down
    drop_table :static_pages
  end
end
