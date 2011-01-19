class ChangeDatatypeForInvitationCodeInGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.change :invitation_code, :string,:limit=>40
    end
  end

  def self.down
  end
end
