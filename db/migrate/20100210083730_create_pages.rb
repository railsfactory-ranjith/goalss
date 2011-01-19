class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name, :limit=>50
      t.string :title, :limit=>100
      t.text :content
      t.string :meta_keywords, :limit=>40
      t.text :meta_description
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
