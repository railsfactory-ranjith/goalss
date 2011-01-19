class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates_format_of :email,:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
end
