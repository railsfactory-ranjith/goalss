class PaidUsersController < ApplicationController
    #require "paypal_pro_recurring"
     # include ActiveMerchant::Billing
      layout "after_login",:except=>["change_plan","group_edit","change_email"]
      before_filter :must_be_logged_in,:except=>['email_activate']
  def select_plan
    @plan=PricingPlan.find(:all)
    @groups=current_user.groups_owned
  end
  
  def add_plan  
puts "cooooooooooooooooooooooooooooooooooooooooooooool"	  
    @groups=current_user.groups_owned
    @plan=PricingPlan.find(:all)
    if params[:user]
      @user_plan=params[:user][:plan]
      @coupon_code=params[:user][:coupon_code]
    else 
      @user_plan=PricingPlan.find_by_id(current_user.pricing_plan_id)
      @user_plan=1 if PricingPlan.find_by_id(current_user.pricing_plan_id).nil?
    end
    if !@coupon_code.blank?
      @coupon=CouponCode.find_by_code(params[:user][:coupon_code])
      if @user_plan=="1" && !@coupon.nil?
        redirect_to :controller=>"group",:action=>"new",:id=>current_user.id
      else
        if !@coupon.nil?
		puts "cooooooooooooooooooooooooooooooooooooooooooooool"
		puts @coupon_code
		
          redirect_to :action=>"pay_bill",:plan=>@user_plan,:coupon_code=> @coupon_code
        else
          flash.now[:error]="Invalid Coupon Code"
          render :action=>"select_plan"
        end
      end
    else
      if @user_plan=="1"
        redirect_to :controller=>"group",:action=>"new",:id=>current_user.id
      else
redirect_to :action=>"pay_bill",:plan=>@user_plan,:coupon_code=> @coupon_code
      end
    end
  end
  
  
  def pay_bill

  end
  
   def create_pay_bill
    @check1 = 0 
    @check2 = 0 
    @check3=0
    @check4=0
    @user_billing_informations=UserBillingInformation.new(params[:user_billing_informations])
    @user_creditcards = UserCreditcard.new(params[:user_creditcards])
    @check1 = 1 if @user_billing_informations.valid?
    @check2 = 1 if @user_creditcards.valid?
    #@check3 = 1 if @user_creditcards.
    cvv_check(params[:user_creditcards][:card_type],params[:user_creditcards][:ccv_number])
    @check4 = 1 if params[:user_creditcards][:last_digit].length == 16
    if @check1 == 1 && @check2 == 1 && @check3 == 1 && @check4 == 1
        #~ @user_billing_informations=UserBillingInformation.new(params[:user_billing_informations])
        @user_billing_informations.user_id=current_user.id
        cc= credit_card_detail(params)
        if @user_billing_informations.valid? && cc==true
          @user_billing_informations.save
          #current_user.update_attributes(:pricing_plan_id=>params[:plan],:is_free_user=>0)
          current_user.pricing_plan_id=params[:plan]
          current_user.is_free_user=0
          current_user.save
         # redirect_to :action => "edit",:id=>current_user.id  # reirect to group
         flash[:paid_user]="Your account has been converted to a paid account"
         redirect_to :controller=>"groups", :action => "new" # reirect to group
        else
            flash.now[:error] = "Provide valid card details"
           render :action=>"pay_bill",:plan=>params[:plan],:coupon=>params[:coupon]
       end
    else
        flash.now[:error] = "Provide valid card number" if @check4 != 1
           render :action=>"pay_bill",:plan=>params[:plan],:coupon=>params[:coupon]
    end        
  end

  def cvv_check(type,ccv)
     
      if (type=="VISA" || type=="Master card" )&& !ccv.blank?
          @check3=1 if ccv.length==3
           flash.now[:error] = "CVV number should be 3 characters"
      elsif type=="American Express" &&  !ccv.blank?
         @check3=1 if ccv.length==4
          flash.now[:error] = "CVV number should be 4 characters"
      end          
  end

  def check_for_empty(params)
    @empty_check = 0
    params && params.each { |param|
      @empty_check = 1 if param[1].empty?
      break if param[1].empty?
    }
    if @empty_check == 0
      return true
    else
      return false  
    end         
  end
  
  def credit_card_detail(params)
    @pricing_plan=PricingPlan.find_by_id(params[:plan])
    #@amount=@pricing_plan.amount
    @amount=discount(params[:coupon],@pricing_plan.amount)
    discount=@pricing_plan.amount-@amount
    @coupon=CouponCode.is_valid_coupon(params[:coupon])
    find_next_renewal = 30 + 1
	  billing_starting_from = Time.now.advance(:months =>find_next_renewal)
	  billing_starting_at = (Time.now.advance(:months =>find_next_renewal)).strftime("%Y-%m-%dT00:00:00")
	  card ||= ActiveMerchant::Billing::CreditCard.new(
          :number => params[:user_creditcards][:last_digit],
            :verification_value => params[:user_creditcards][:ccv_number],
            :month => params[:user_creditcards][:exp_month],
            :year => params[:user_creditcards][:exp_year],
		    :first_name => current_user.user_profile.first_name, #Have to find some other solution for filling this firstname and last name.This is temporarily done.
		    :last_name => current_user.user_profile.last_name
		)	
         options = {
		:name => current_user.user_profile.first_name,
		:email => current_user.email,
		:starting_at => billing_starting_at,
		:periodicity => :daily,
		:comment => 'Credit Card details updating',
		:billing_address => current_user.user_profile.mailing_address1
		}
    recurring_amt = @amount*100
    if card.valid?		
      @response = creditcard_gateway.create_profile(options, :credit_card => card, :description => "description", :start_date => Time.now+100 , :frequency => 1 , :amount => recurring_amt, :initial_amount =>recurring_amt,:cycles=>3)
      if @response.success?
        recurring_response_profile_id = @response.params['profile_id']
 				@u=UserCreditcard.new(:recurring_profile_id=>recurring_response_profile_id,:user_id=>current_user.id,:last_digit=>(params[:user_creditcards][:last_digit])[-4..-1],:exp_year=>params[:user_creditcards][:exp_year],:exp_month=>params[:user_creditcards][:exp_month],:ccv_number=>params[:user_creditcards][:ccv_number],:card_type=>params[:user_creditcards][:card_type])								
				@u.save
        @subscription=Subscription.new(:user_id=>current_user.id,:pricing_plan_id=>@pricing_plan.id,:next_renewal_at=>Date.today.next_month,:billing_start_date=>Date.today,:billing_end_date=>Date.today.next_month,:card_type=>params[:user_creditcards][:card_type],:amount=>@amount,:is_success=>true)
        @subscription.coupon_code_id=@coupon.id if @coupon
        @subscription.discount_amount=discount
        @subscription.save
        @payment=Payment.new(:user_id=>current_user.id,:pricing_plan_id=>params[:plan],:subscription_id=>@subscription.id,:amount=>@amount,:transaction_id=>@response.params['transaction_id'], :card_4digit=>params[:user_creditcards][:last_digit],:exp_month=>params[:user_creditcards][:exp_month],:exp_year=>params[:user_creditcards][:exp_year],:gateway_response=>@response.params['ack'],:description=>@response.params['message'],:is_success=>"true")
        @payment.save
        current_user.update_attributes(:pricing_plan_id=>params[:plan])
        current_user.update_paiduser_plan(params[:plan])
        flash[:notice] = 'Your plan was successfully updated.'
        return true
			else
        flash[:error] = "Provide valid card details"
        return false
      end	
		else
      flash[:error_card] = "Provide Valid Card details"
      return false
    end	
  end
    
    
    def samp
        @response = creditcard_gateway.get_profile_details('I-BW40VHLNGS1G')
        #puts @response.inspect      
    end
  
  
  def edit
    edit_information
  end
  
  def update
    user_billing,user_profile=false
    @user_billing_info=current_user.user_billing_information
    @cc_detail=current_user.user_creditcards.find(:last)
    @user_profile=current_user.user_profile
    @groups=current_user.groups.paginate :order =>params[:order], :page=>params[:page],:per_page=>ENTRIES_PER_PAGE
    #@user_plan=PricingPlan.find_by_id(current_user.pricing_plan_id)
    @user_plan=current_user.user_plan
    @active_groups=current_user.groups_owned
    @user_billing_info.attributes=params[:user_billing_info]
    @user_profile.attributes=params[:user_profile]
    contacts_changed=@user_profile.changed?
    user_billing=true if @user_billing_info.valid? 
    user_profile=true if @user_profile.valid?
    if user_billing && user_profile
      @user_billing_info.update_attributes(params[:user_billing_info]) 
      @user_profile.update_attributes(params[:user_profile])
      @user_profile.update_attributes(:first_name=>params[:user_profile][:first_name].capitalize,:last_name=>params[:user_profile][:last_name].capitalize)
      current_user.send_contacts_changed_mail if contacts_changed
      redirect_to :action =>'edit',:id=>current_user.id
    else
      render :action =>'edit',:id=>current_user.id
    end
  end
  
   
  def change_plan
    @groups=current_user.groups_owned
    @plan=PricingPlan.find(:all)
    if current_user.is_free_user
      @pla=PricingPlan.find(1)
      @current_plan="1"
    else
      @pla=PricingPlan.find(current_user.pricing_plan_id)
      @current_plan=current_user.pricing_plan_id
    end
    @active_plans=PricingPlan.find(:all,:conditions=>['is_active=?',true]).size
  end
  
  def update_plan
    @grous=current_user.groups_owned
    if params[:user]
      @plans=PricingPlan.find(params[:user][:plan])
      if @plans.id==1
        @user_card=current_user.user_creditcard
        options = {
        :name => current_user.user_profile.first_name,
        :email => current_user.email
        }
        @response = creditcard_gateway.cancel_profile(@user_card.recurring_profile_id , options)
        if @response.success?
          current_user.update_attributes(:is_free_user=>true,:pricing_plan_id=>nil)
          current_user.update_userplan
          flash[:notice]="You have successfully changed into a free user"
          redirect_to :controller=>"users",:action => 'edit',:id=>current_user.id
        else 
          flash[:error]="Sorry cannot change your plan currently, please try again"
          redirect_to :action => 'edit',:id=>current_user.id
        end
      else
        if @grous.count <= @plans.max_group
          @u=current_user.user_creditcard
          #~ find_next_renewal = 30 + 1
          #~ billing_starting_from = Time.now.advance(:months =>find_next_renewal)
          #~ billing_starting_at = (Time.now.advance(:months =>find_next_renewal)).strftime("%Y-%m-%dT00:00:00")
          #~ card ||= ActiveMerchant::Billing::CreditCard.new(
                #~ :number => @u.last_digit,
                  #~ :verification_value => @u.ccv_number,
                  #~ :month => @u.exp_month,
                  #~ :year =>@u.exp_year,
              #~ :first_name => current_user.user_profile.first_name, #Have to find some other solution for filling this firstname and last name.This is temporarily done.
              #~ :last_name => current_user.user_profile.last_name
          #~ )	
          
          #~ options = {
          #~ :name => current_user.user_profile.first_name,
          #~ :email => current_user.email,
          #~ :starting_at => billing_starting_at,
          #~ :periodicity => :daily,
          #~ :comment => 'Credit Card details updating',
          #~ :billing_address => current_user.user_profile.mailing_address1,
              #~ :initial_payment =>(current_user.pricing_plan.amount)*100
          #~ }
          pricing_plan= PricingPlan.find_by_id(params[:user][:plan])
          @response = creditcard_gateway.update_profile(@u.recurring_profile_id 	,:description => "description", :start_date => Time.now , :frequency => 1 , :amount => pricing_plan.amount*100)
          if @response.success?
            current_user.update_attribute(:pricing_plan_id,params[:user][:plan])
            current_user.update_paiduser_plan(params[:user][:plan]) 
            flash[:notice]= "Plan is changed"
            redirect_to :action => 'edit',:id=>current_user.id
          else
            flash[:error]="Sorry plan not changed, try again later"
            redirect_to :action => 'edit',:id=>current_user.id
          end
        else
          flash[:error]="plan not changed"
          redirect_to :action => 'edit',:id=>current_user.id
        end
      end
    else
      flash[:notice]="Plan not changed"
      redirect_to :action => 'edit',:id=>current_user.id
    end
  end
  
   def group_update
    @group=Group.find(params[:id])
    if @group.group_leader_id.nil?
      @leader_name=""
    else
      @leader=User.find_by_id(@group.group_leader_id)
      @leader_name=@leader.user_profile.first_name+' '+ @leader.user_profile.last_name
    end
  end
  
  def change_status
   @group=Group.find(params[:id])
   @user_plan=@group.user.user_plan
   @k=true
   free_change_status_group(@group,@user_plan) if current_user.is_free_user
    if params[:activegroup]
      if @user_plan.max_group > current_user.groups_owned.count && @k
        @group.update_attributes(:is_active=>true)
      else
        flash[:group_sus_err]="Sorry, your current plan allows you to have only #{@user_plan.max_group} active groups" 
        flash[:group_sus_err]="Sorry, Please update your plan" if @k==false
      end
    else
      @group.update_attributes(:is_active=>false)
    end
    redirect_to :action=>'group_update',:id=>params[:id]
  end
  
  def group_edit
    @group=Group.find(params[:id])
    @members=@group.active_members
  end
  
  def change_leader
    @group=Group.find(params[:id])
    @members=@group.group_users
    if params[:group][:group_leader_id].blank? 
      render :update do |page|
        page.replace_html "leader_error","Please select the leader"
      end
    else
      @group.update_attributes(params[:group])
      @leader_name=User.find_by_id(@group.group_leader_id).user_profile.first_name
      @status_update=Post.new(:user_id=>current_user.id,:group_id=>@group.id,:content=>" changed the leader as #{@leader}",:is_group_log=>true)
      @status_update.save
      flash[:notice]="The group leader has been changed"
      render :update do |page|
        page.redirect_to :action=>'group_update' ,:id=> @group.id
      end
    end
  end
  
  def invite_leader
    @group=Group.find(params[:id])
    if params[:group][:leader_email_invite].empty?
      render :update do |page| 
        page.replace_html "errorpop","Please enter the email Id"
      end
    else
      params[:group][:invited_at]=Time.now
      if @group.update_attributes(params[:group])
        code=Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
        @group.update_attributes(:invitation_code=>code,:invited_at=>Time.now)
        UserMailer.deliver_invite_leader(current_user,code,@group)
        render :update do |page|
          page.redirect_to :action=>'group_update' ,:id=> @group.id
          flash[:notice]= "The group leader invitation has been sent"
        end
      else
        render :update do |page| 
          page.replace_html "errorpop",@group.errors["leader_email_invite"].to_a[0]
        end
      end
    end
end
  
  def update_creditcard
    
    edit_information
    if params[:x]
      find_next_renewal = 30 + 1
      billing_starting_from = Time.now.advance(:months =>find_next_renewal)
      billing_starting_at = (Time.now.advance(:months =>find_next_renewal)).strftime("%Y-%m-%dT00:00:00")
      card ||= ActiveMerchant::Billing::CreditCard.new(
            :number => params[:user_creditcards][:last_digit],
              :verification_value => params[:user_creditcards][:ccv_number],
              :month => params[:user_creditcards][:exp_month],
              :year => params[:user_creditcards][:exp_year],
          :first_name => current_user.user_profile.first_name, #Have to find some other solution for filling this firstname and last name.This is temporarily done.
          :last_name => current_user.user_profile.last_name
      )	
           options = {
      :name => current_user.user_profile.first_name,
      :email => current_user.email,
      :starting_at => billing_starting_at,
      :periodicity => :daily,
      :comment => 'Credit Card details updating',
      :billing_address => current_user.user_profile.mailing_address1,
          :initial_payment =>(current_user.pricing_plan.amount)*100
      }
      recurring_amt = (30)*100
      if card.valid?		
        @u=current_user.user_creditcard
        @old_card=Oldcreditcard.new(:user_id=>current_user.id,:last_4digit=>@u.last_digit,:exp_year=>@u.exp_year,:exp_month=>@u.exp_month,:card_type=>@u.card_type,:ccv_number=>@u.ccv_number,:recurring_profile_id=>@u.recurring_profile_id)
        @response = creditcard_gateway.update_profile(@u.recurring_profile_id 	, :credit_card => card, :description => "description", :start_date => Time.now , :frequency => 1 , :amount => current_user.pricing_plan.amount)
        if @response.success?
          recurring_response_profile_id = @response.params['profile_id']
          #@u=current_user.user_creditcard          
          @u.update_attributes(:recurring_profile_id=>recurring_response_profile_id,:user_id=>current_user.id,:last_digit=>(params[:user_creditcards][:last_digit])[-4..-1],:exp_year=>params[:user_creditcards][:exp_year],:exp_month=>params[:user_creditcards][:exp_month],:ccv_number=>params[:user_creditcards][:ccv_number],:card_type=> params[:user_creditcards][:card_type])					
          #@u=UserCreditcard.new(:recurring_profile_id=>recurring_response_profile_id,:user_id=>current_user.id,:last_digit=>(params[:user_creditcards][:last_digit])[-4..-1],:exp_year=>params[:user_creditcards][:exp_year],:exp_month=>params[:user_creditcards][:exp_month],:ccv_number=>params[:user_creditcards][:ccv_number],:card_type=>card.type)
          #@u.save
          @old_card.save
          flash[:notice] = 'Your credit card information was successfully updated'
          redirect_to :action=>"edit", :id=>current_user.id
        else
          flash.now[:error] = "Provide valid card details"
          render :action=>"edit", :id=>current_user.id
        end	
      else
        flash.now[:error] = "Previously entered card detail was invalid. The old card detail is retained."
        render :action=>"edit", :id=>current_user.id  
      end	 
    else
      render :action=>"edit", :id=>current_user.id   
    end
  end



  def edit_information
    @user_billing_info=current_user.user_billing_information
    @user_profile=current_user.user_profile
    @groups=current_user.groups_owned
    @groups_count=@groups.count
    @groups=@groups.paginate(:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @active_groups=current_user.groups_owned
    @user_plan=current_user.user_plan
    @cc_detail=current_user.user_creditcards.find(:last)
  end


  #~ def create_pay_bill
    #~ @user_billing_informations=UserBillingInformation.new(params[:user_billing_informations])
    #~ @user_billing_informations.user_id=current_user.id
    #~ if @user_billing_informations.valid?
      #~ @user_billing_informations.save
      #~ current_user.update_attribute(:pricing_plan_id,params[:plan])
      #~ redirect_to :action => "edit",:id=>current_user.id
    #~ else
      #~ render :action=>"pay_bill"
    #~ end
  #~ end
  def group_list
    @group=current_user.groups
    if params[:order]== "first_name" 
    @user=User.find_all_by_id(@group.collect{|u| u.group_leader_id},:order=>"user_profiles.first_name",:include=>:user_profile)
    sorted_sort
    elsif params[:order]=="first_name DESC"
    @user=User.find_all_by_id(@group.collect{|u| u.group_leader_id},:order=>"user_profiles.first_name DESC",:include=>:user_profile)
    sorted_sort
    else
    @groups=current_user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    end
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_lists",:partial=>'group_list'
      end                        
    end
  end
  
  def billing_history
    @historys=current_user.payments
    @user_card=current_user.user_creditcard
    @response=creditcard_gateway.get_profile_details(@user_card.recurring_profile_id)    
  end

  def close_profile
    self.current_user=User.find(:first,:conditions=>['id =? ', params[:id]])
    @u=current_user.user_creditcard
     options = {
      :name => current_user.user_profile.first_name,
      :email => current_user.email
      }
    @response = creditcard_gateway.cancel_profile(@u.recurring_profile_id , options)
    if @response.success?
      current_user.update_attributes(:close_code=>nil) if !current_user.nil?
      redirect_to '/'
    else 
      flash[:error]="Cannot close your account please try again"
      redirect_to :action=>"edit",:id=>current_user.id
    end
  end
  
  def find_billing
    @s=Subscription.yesterday_payment
    #@s=Subscription.find :all
    open('myfile.txt', 'a') { |f|
    @s.each do |sub|
      profile_id=sub.user.user_creditcard.recurring_profile_id
      @response=creditcard_gateway.get_profile_details(profile_id)
      f<<@response.inspect
    end
    }
  end
        
  def discount(coupon,amount)
    @coupon_code=CouponCode.is_valid_coupon(coupon)
    if @coupon_code
      if @coupon_code.coupon_type=="%"
        amount=amount-(amount*@coupon_code.value.to_f/100)
      else
        amount=amount-@coupon_code.value.to_f
      end
    end
    return amount
  end  
  def change_email
    if params[:users]
      @user=User.find(current_user.id)
      @u = User.authenticate(current_user.email,params[:users][:password])
      primary_activation= Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      @user.update_attributes(:primary_email=>params[:users][:primary_email],:primary_activiation_code=>primary_activation) if @u && params[:users][:primary_email]==params[:users][:primary_email1]
      if @user.valid? && @u && params[:users][:primary_email]==params[:users][:primary_email1]
        UserMailer.deliver_change_email_notification(@user)
        render :update do |page| 
           page <<"close_pop();" 
           page.replace_html "success_email","An email with your account information has been sent to you at:#{@user.primary_email}"
        end
      else
        render :update do |page| 
          if params[:users][:password].blank?
             page.replace_html "password_error","Password cant be blank" 
             else
          page.replace_html "password_error","please enter the valid password" if !@u
        end
        if (params[:users][:primary_email]).blank?
          page.replace_html "email_error","Email and Re-enter Email address cant be blank" 
        elsif ((params[:users][:primary_email]).match  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).nil?
          page.replace_html "email_error","please enter the valid email id" 
          elsif  params[:users][:primary_email]!=params[:users][:primary_email1]
          page.replace_html "email_error","Email and Re-enter Email address mismatch" 
          end
             end
      end
    end
  end
  def email_activate
  @user=User.find_by_primary_activiation_code(params[:primary_activiation_code])
  if !@user.nil?
  @user.update_attributes(:primary_activiation_code=>"null",:email=>@user.primary_email)
   flash[:notice]="Email has been changed successfully"
  end
    if current_user
    redirect_to :controller=>"activities",:action=>'index'
    else
    redirect_to :controller=>"session", :action => 'new'
    end
  end
    def free_change_status_group(group,user_plan)
      @k=true
      if !user_plan.day.nil?
      days=(Time.now-group.created_at)/86400
      @k=(days > user_plan.day)? false : true 
      end
    end
end
