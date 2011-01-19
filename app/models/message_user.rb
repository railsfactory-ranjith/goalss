class MessageUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  


  def self.trash(user)
    user.message_users.find(:all,:conditions=>['is_trash = ?',true])
  end
end
