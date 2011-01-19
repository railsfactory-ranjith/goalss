class BetaInvit < ActiveRecord::Base
    belongs_to :demographic
    validates_presence_of :first_name, :message =>"can't be blank"
    validates_length_of :first_name,:within =>1..40,:message=>"First Name should be within  1 to 40 characters"
    validates_format_of :first_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a name without special characters"
     validates_presence_of :last_name, :message =>"can't be blank"
    validates_length_of :last_name,:within =>1..40,:message=>"First Name should be within  1 to 40 characters"
    validates_format_of :last_name,:with=>/^([a-zA-Z\s_])*$/,:message=>"Please enter a name without special characters"
    validates_length_of :organization,:maximum => 50,:message=> "Companyname should within 50 characters"
    validates_presence_of :organization,:zipcode, :message =>"can't be blank"
    validates_length_of :occupation,:maximum => 50,:message=> "Occupation should within 50 characters"
    validates_presence_of :occupation, :message =>"can't be blank"
    validates_numericality_of :demographic_id,:message=>"can't be blank"
    validates_length_of :zipcode,:within=>2..10,:message=>"Postal code should be within 2 to 10 characters"
    validates_format_of :zipcode,:with=>/^([a-zA-Z0-9\s_\-])*$/,:message=>"Invalid "
    validates_presence_of :dob,:message =>"can't be blank"
    validates_presence_of :country,:message =>"can't be blank"
    validates_length_of :referred_by,:within =>1..100,:message=>"First Name should be within  1 to 100 characters",:allow_blank => true
    validates_presence_of :invitation_msg, :message =>"can't be blank"
    validates_length_of :invitation_msg,:within =>1..1000,:message=>"Max 1000 characters"
    validates_presence_of     :email
    validates_length_of       :email,    :within => 3..100, :message=>"Max 100 and Min 3"
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
