class CouponCode < ActiveRecord::Base
  has_many :subscriptions
  validates_uniqueness_of :code
  validates_numericality_of :code

  def self.find_coupon(code)
    self.find_by_code(code,:conditions=>['is_active=? AND is_deleteds is null',true])
  end
  
  def self.is_valid_coupon(code)
    @coupon_code=self.find_coupon(code)
    unless @coupon_code.nil?
      from=true if @coupon_code.active_from.nil? || Time.now>=@coupon_code.active_from
      to=true if @coupon_code.active_to.nil? || Time.now<=@coupon_code.active_to
      if from && to
        return @coupon_code
      else
        return false
      end
    else
      return false
    end
  end
end
