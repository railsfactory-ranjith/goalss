class Admin::BillingInformationsController < AdminsController
  layout "admin_login",:except=>["select_plan"]
   
  def owner_account
    @group=Group.find(params[:id])
    @g=User.find(@group.user_id)
    @billing=UserBillingInformation.find_by_user_id(@group.user_id)
    @creditcard=UserCreditcard.find_by_user_id(@group.user_id)
    @group_count= @group.user.groups.find(:all,:conditions=>['is_active=?',1])
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    if (@group.user.pricing_plan_id==1) || (@group.user.pricing_plan_id == nil)
       render :action =>'update_free_account',:id=>@group.id
    else
      @plan=@group.user.user_plan
    end
  end
  def select_plan
    @group=Group.find(params[:id])
    @grous=@group.user.groups
    @plans=PricingPlan.find(:all)
    @pla=PricingPlan.find(@group.user.pricing_plan_id)
    @current_plan=@group.user.pricing_plan_id 
  end
  def update_plan
    @group=Group.find(params[:id])
    @mess="Plan changed for"
    @group_all=@group.user.groups.find(:all,:conditions=>['is_active=?',1])
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @plan=@group.user.user_plan
    if @group_all.count<=@plan.max_group
      @group.user.update_attribute(:pricing_plan_id,params[:user][:plan])
    log_updates_for
    flash[:notice]= "Plan is changed"
      redirect_to :action =>'owner_account',:id=>@group.id
    else
      flash[:error]="plan not changed"
      redirect_to :action => 'owner_account',:id=>@group.id
    end
  end
  def update_billing
	  @mess="Billing information updated for"
    @group=Group.find(params[:id])
    @group_count=@group.user.groups.find(:all,:conditions=>['is_active=?',1])
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @plan=@group.user.user_plan
    @billing=UserBillingInformation.find_by_user_id(@group.user_id)
    @billing.attributes=params[:billing]
    @creditcard=UserCreditcard.find_by_user_id(@group.user_id)
    @g=User.find(@group.user_id)
    @g.user_profile.attributes=params[:user_profile]
    if (@g.user_profile.valid? && @billing.valid?)
      @g.user_profile.update_attributes(params[:user_profile])
      @g.user_profile.update_attributes(:first_name=>params[:user_profile][:first_name].capitalize,:last_name=>params[:user_profile][:last_name].capitalize)
      @billing.update_attributes(params[:billing])
     log_updates_for
      flash[:notice]= "Billing information is updated"
      redirect_to :action =>'owner_account',:id=>@group.id
    else
      flash.now[:error]="Billing information is not updated"
      render :action =>'owner_account',:id=>@group.id
    end
  end
  def update_creditcard
	  @mess="Credit Card information updated for"
    @group=Group.find(params[:id])
    @g=User.find(@group.user_id)
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    @plan=@group.user.user_plan
    @billing=UserBillingInformation.find_by_user_id(@group.user_id)
    @creditcard=UserCreditcard.find_by_user_id(@group.user_id)
    if @creditcard.update_attributes(params[:creditcard])
	   log_updates_for
     flash[:notice]= "Credit Card information is updated"
      redirect_to :action =>'owner_account',:id=>@group.id
    else
      flash[:error]="Credit Card information is not updated"
      render :action =>'owner_account',:id=>@group.id
    end
  end
  def update_free_account
    @mess="Billing information updated for"
    @group=Group.find(params[:id])
    @g=User.find(@group.user_id)
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    if params[:update] 
      if @g.user_profile.update_attributes(params[:user_profile])
        @g.user_profile.update_attributes(:first_name=>params[:user_profile][:first_name].capitalize,:last_name=>params[:user_profile][:last_name].capitalize)
        log_updates_for
        flash[:notice]= "Billing information is updated"
        redirect_to :action=>'owner_account',:id=>@group.id
      else
        render :action =>'update_free_account',:id=>@group.id
      end
    else
      render :action =>'update_free_account',:id=>@group.id
    end
  end
  def group_list
    @group=Group.find(params[:id])
    @grous=@group.user.groups.paginate(:all,:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    if request.xml_http_request?
      render :update do |page|      
        page.replace_html "group_lists",:partial=>'group_list'
      end                        
    end
  end
  def billing_history
     @historys=Payment.find_all_by_user_id(params[:id])
     @user=User.find(params[:id])
    end
      def view_log_group
      user_id=params[:id]
    @logs=AdminLog.all.paginate(:conditions =>['user_id = ?',user_id],:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    render :action=>'activity_log'
  end
  def back_link
   redirect_to :back
    end
end


