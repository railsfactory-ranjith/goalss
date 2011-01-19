class CreatePostReads < ActiveRecord::Migration
  def self.up
    create_table :post_reads do |t|
      t.integer :post_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :post_reads
  end
end
