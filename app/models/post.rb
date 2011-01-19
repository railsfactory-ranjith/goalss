class Post < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :comments
  has_many :post_reads
  has_many:user_posts
  has_many:users, :through => :user_posts
  belongs_to :receiver, :class_name => "User"
  has_many :attachments, :as => :attachable,:dependent => :destroy
  belongs_to :attachable,:polymorphic=>true
end
