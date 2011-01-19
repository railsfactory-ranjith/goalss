class Comment < ActiveRecord::Base
	belongs_to :post
  belongs_to :user
  has_many :attachments, :as => :attachable,:dependent => :destroy
  belongs_to :attachable,:polymorphic=>true
end
