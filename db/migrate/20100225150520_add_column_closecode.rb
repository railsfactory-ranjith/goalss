class AddColumnClosecode < ActiveRecord::Migration
  def self.up
      add_column :users, :close_code, :string
  end

  def self.down
      remove_column :objectives, :due_date, :datetime
  end
end
