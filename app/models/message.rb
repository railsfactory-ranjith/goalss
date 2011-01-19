class Message < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :message_users
  has_many :users, :through => "message_users"
    has_many :attachments, :as => :attachable,:dependent => :destroy
  belongs_to :attachable,:polymorphic=>true
  
  def self.thread_messages(parent_id)
    self.find(:all,:conditions=>['parent_id=?',parent_id])
  end
end
