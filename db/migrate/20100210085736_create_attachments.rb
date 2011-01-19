class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type, :limit=>100
      t.string :content_type, :limit=>100
      t.string :filename, :limit=>100
      t.string :thumbnail, :limit=>100
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
