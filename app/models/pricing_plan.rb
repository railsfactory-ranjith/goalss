class PricingPlan < ActiveRecord::Base
  has_one :subscription
  has_many :payments
  validates_numericality_of :amount,:max_group ,:message=>"enter numbers"   
  validates_numericality_of :max_users_in_group ,:message=>"enter numbers"   
  validates_numericality_of :day,:greater_than=>6
  validates_inclusion_of  :max_users_in_group,:amount,:max_group,:in => 1..100000,:message=> "zero not allowed"
  #validates_length_of :max_users_in_group,:within => 1..3
end
