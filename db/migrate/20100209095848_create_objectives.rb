class CreateObjectives < ActiveRecord::Migration
  def self.up
    create_table :objectives do |t|
					t.integer :group_id
					t.string :title,:limit=>100
					t.text :description
					t.date :due_date
      t.timestamps
    end
  end

  def self.down
    drop_table :objectives
  end
end
