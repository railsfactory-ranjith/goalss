class GroupUser < ActiveRecord::Base
	  belongs_to :user
			belongs_to :group
      
      
  def self.group_color(group_id,user_id)
    @color=self.find(:first,:conditions=>['group_id = ? AND user_id = ?',group_id,user_id])
    if @color.nil? || @color.color_code.nil?
      "#ffffff"
    else
      "#"+@color.color_code
    end
  end

  def active_members
    find(:all,:conditions=>['is_active = ? AND is_deleted = ?',true,false])
  end
  
  def self.find_group_member(group_id,user_id)
    self.find(:first,:conditions=>["group_id = ? AND user_id = ?",group_id,user_id])
  end
end
