class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :pricing_plan
  belongs_to :coupon_code
  has_many :payments
  
  def self.yesterday_payment
    self.find(:all,:conditions=>['next_renewal_at =?',Time.now.yesterday.to_date])
  end
end
