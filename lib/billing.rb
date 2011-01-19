#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
class Getbilling<ApplicationController
  def find_billing
    @s=Subscription.yesterday_payment
    #~ open("#{RAILS_ROOT}/myfile.txt", 'a') { |f|
    @s.each do |sub|
      profile_id=sub.user.user_creditcard.recurring_profile_id
      @response=creditcard_gateway.get_profile_details(profile_id)
      if @response.success?
        @subscription=sub.user.subscriptions.new(:pricing_plan_id=>sub.user.pricing_plan_id,:next_renewal_at=>@response.params['next_billing_date'],:billing_start_date=>@response.params['billing_start_date'],:billing_end_date=>@response.params['next_billing_date'],:card_type=>@response.params['credit_card_type'],:amount=>@response.params['last_payment_amount'])
        if is_negative(@response.params['outstanding_balance'].to_f)
          @subscription.is_success=false
          UserMailer.deliver_billing_failed(sub)
        else
          @subscription.is_success=true
        end
        @subscription.save
      end
      #~ f.puts @response.inspect
      #~ f.puts Time.now
    end
    #~ }
  end
  
  def is_negative(num)
    num != 0 && (num != (num * num / num.abs))
  end
end

b=Getbilling.new
b.find_billing
