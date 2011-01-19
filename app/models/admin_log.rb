class AdminLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :admin
  belongs_to :objective
end
