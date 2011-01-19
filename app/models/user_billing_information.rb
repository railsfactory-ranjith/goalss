class UserBillingInformation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :first_name,:last_name,:address_1,:city,:country,:state,:zipcode, :phonenumber,:email_address,:message=>"Fields cannot be empty"
  validates_length_of :first_name, :within => 1..40 ,:too_short =>"Please enter a longer name",:too_long =>"Please enter a shorter name"
  validates_format_of :first_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a valid name"
  validates_length_of :last_name, :within => 1..40,:too_short =>"Please enter a longer name",:too_long =>"Please enter a shorter name"
  validates_format_of :last_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a valid name"
  validates_length_of :company_name, :within=>5..100,:message=>"Please enter a valid Organization name",:allow_blank => true
  validates_length_of :address_1,:maximum=>150,:message=>"Address should be less than 150 characters"
  validates_length_of :address_2,:maximum=>150,:message=>"Address should be less than 150 characters"
  validates_length_of :city,:maximum=>40,:message=>"Please enter a valid city"
  validates_format_of :city,:with=>/^([a-zA-Z\s])*$/,:message=>"Please enter a valid city"
  validates_length_of :zipcode,:within => 2..10, :message=>"Please enter a valid postal code"
  validates_format_of :phonenumber,:with=>/^[+\/\-() 0-9]+$/,:message=>"is invalid",:allow_blank => true
	validates_length_of :phonenumber,:within=>6..20,:message => "is invalid",:allow_blank => true
  validates_format_of :email_address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:allow_blank => true
end
