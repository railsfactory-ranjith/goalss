class UserPost < ActiveRecord::Base
     belongs_to :user
     belongs_to :post
     
  def unread
     find(:all,:conditions=>['is_read=false'])
   end

def latest
  find(:all,:limit=>20)
end
     
def next_20(i)
  find(:all,:limit=>i+20)
end
     
end
