class Objective < ActiveRecord::Base
	
	has_many :objective_users 
	has_many :users ,:through => :objective_users
	belongs_to :group
  has_many :group_users,:through=>:group
  validates_presence_of :title,:message=>"Objective name cannot be empty"
  validates_length_of :title,:within=>5..100,:too_short=>"Objective name should be atleast 5 characters",:too_long=>"Objective name should be less than 100 characters"
  validates_length_of :description,:maximum=>500,:message=>"Objective description should be within 500 characters"
  
  def due_in_7_days
    find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
  end
  
  def self.upcoming_objectives_groups(group_ids)
    self.find(:all,:conditions=>{'group_id'=>group_ids.collect{|group_id| group_id},'due_date'=>Date.today..Date.today+7} )
  end
  
  def self.objective_responsibility(user_id)
    self.find(:all,:conditions=>['objective_users.user_id=? AND group_users.is_active=? AND groups.is_active=?',user_id,true,true],:include=>[{:group=>"group_users"},:objective_users])
  end
    
  def responsible_members
    responsible_members=[]
    self.objective_users.each do|obj_user|
      mem=self.group.group_users.find_by_user_id_and_is_active(obj_user.user_id,true)
      responsible_members<<mem if mem
    end
    return responsible_members
  end  
end
