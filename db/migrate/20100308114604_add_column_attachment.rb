class AddColumnAttachment < ActiveRecord::Migration
  def self.up
      add_column :attachments, :size, :integer
  end

  def self.down
      remove_column :attachments, :size
  end
end
