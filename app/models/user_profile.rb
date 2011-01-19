class UserProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :demographic
  belongs_to :industry
	validates_presence_of :first_name, :message =>"can't be blank"
  validates_presence_of :last_name,:message =>"can't be blank"
  validates_presence_of :zipcode, :message =>"can't be blank      "
  #validates_presence_of :industry_id,:message =>"Fields can't be blank"
  validates_presence_of :dob,:message =>"can't be blank"
  validates_presence_of :country,:message =>"can't be blank"
	#validates_presence_of :country, :message => "Please select Country."
	#validates_length_of :password, :message=>"Password should be a minimum of 6 characters", :within => 6..40
	validates_length_of :first_name,:within =>1..40,:message=>"First Name should be with 1 to 40 characters"
  validates_format_of :first_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a valid first name"
	validates_length_of :last_name,:within=>1..40,:message=> "Last Name should be with 1 to 40 characters"
	validates_format_of :last_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a valid last name"
	validates_length_of :organization,:maximum => 50,:message=> "Companyname should within 50 characters",:allow_blank => true
	validates_length_of :occupation,:maximum => 50,:message=> "Occupation should within 50 characters",:allow_blank => true
  validates_format_of :office_email_address, :personal_email_address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,:allow_blank => true
  validates_length_of:yahoo_id,:windows_live_id,:aim_id,:skype_id, :maximum=>40,:allow_blank => true
	
  validates_length_of :mailing_address1,:mailing_address2,:maximum=>150,:message => "Address should within 150 characters",:allow_blank => true
  validates_format_of :city,:state,:with=>/^([a-zA-Z\s_])*$/,:message=>"Invalid ",:allow_blank => true
  validates_length_of :city,:maximum=>50,:message=>"City should be within 50 characters",:allow_blank => true
	validates_length_of :state,:maximum=>50,:message=>"State should be within 50 characters",:allow_blank => true
  validates_length_of :zipcode,:within=>2..10,:message=>"Postal code should be within 2 to 10 characters"
  validates_format_of :zipcode,:with=>/^([a-zA-Z0-9\s_\-])*$/,:message=>"Invalid "
  #~ validates_format_of :mobile_phone,:office_phone,:with=>/^[+\/\-() 0-9]+$/,:message=>"is invalid",:allow_blank => true
	validates_length_of :mobile_phone,:office_phone,:within=>6..30,:message => "is invalid",:allow_blank => true
  #~ validates_numericality_of :mobile_phone,:office_phone,:allow_blank => true
  validates_numericality_of :demographic_id,:message=>"can't be blank"
  validates_presence_of :gender,:message=>"can't be blank" 
  attr_accessible :first_name, :last_name,:organization, :occupation, :office_email_address, :personal_email_address, :mobile_phone, :office_phone, :yahoo_id, :windows_live_id, :aim_id, :skype_id, :mailing_address1, :mailing_address2, :city, :state, :country,:zipcode,:gender,:dob, :industry_id, :demographic_id,:user_id,:time_zone,:date_format,:other_info,:title	
 
end
