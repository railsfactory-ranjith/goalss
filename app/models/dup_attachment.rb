class DupAttachment < ActiveRecord::Base
	#~ has_many :attachments, :as => :attachable,:dependent => :destroy
  #~ belongs_to :attachable,:polymorphic=>true
   belongs_to :attachment
end
