namespace :suspend do
  desc  "Suspend the group which are above the timeline activate the group which are below the timeline"
  task :free_group => :environment  do
    @free_use_days=PricingPlan.find(:first).day
    @users=User.find(:all,:conditions=>['is_free_user=?',true])
    @users.each do |user|
      @groups=user.groups
      @groups.each do |group|
        if (Time.now-group.created_at)/(60*60*24)>=@free_use_days
          group.update_attribute(:is_active,false)
        else
          #group.update_attribute(:is_active,true) if group.user.state.nil?
        end
      end
    end
  end
  
  
  desc  "Suspend the group of the failed payments"
  task :paid_group => :environment  do
    @users=User.find(:all,:conditions=>['is_free_user=?',false])
    @users.each do|user|
      @subscription=user.subscriptions.last if user.state.nil?
      @card_declined=@subscription.updated_at unless @subscription || @subscription.nil?|| @subscription.is_success
      if @card_declined 
        @groups=user.groups
        @allowed_hours=PricingPlan.first.hours
        @groups.each do |group|
          if ((Time.now-@subscription.updated_at)/(60*60))>= @allowed_hours.to_i
            group.update_attribute(:is_active,false)
          end
        end
          UserMailer.deliver_send_group_suspend_notification(user)
      end
    end
  end
end
        