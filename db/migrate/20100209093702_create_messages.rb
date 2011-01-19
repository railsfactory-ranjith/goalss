class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :group_id
      t.integer :user_id
      t.string :subject
      t.text :message
      t.boolean :is_draft
      t.boolean :is_focused
      t.boolean :is_closed
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
