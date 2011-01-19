class ChangeCommentDatatype < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.change :content, :text
    end
  end

  def self.down
  end
end
