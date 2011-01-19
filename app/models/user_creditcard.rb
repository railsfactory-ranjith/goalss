class UserCreditcard < ActiveRecord::Base
    belongs_to :user
  validates_presence_of    :last_digit,:card_type,:ccv_number,:message=>"can't be blank"
  validates_presence_of    :exp_year,:message=>"year can't be blank"
  validates_presence_of    :exp_month,:message=>"month can't be blank"
  validates_numericality_of :ccv_number,:message=>"alphanumeric is not allowed"
  validates_numericality_of :last_digit,:message=>"alphanumeric is not allowed"
  
end
