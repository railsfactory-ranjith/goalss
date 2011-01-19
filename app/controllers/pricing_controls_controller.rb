class PricingControlsController < AdminsController
  layout "admin_login"
  #before_filter :must_be_admin_user_logged_in,:only=>['edit','update','coupon_update']
  @count=1
  def edit
    @plans=PricingPlan.find(:all)
    @coupons=CouponCode.find(:all)
    #if @coupons.nil?
    @count=1
    #end
  end
  def promotions
	  puts "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
    @count=params[:count] if params[:count]
    render :update do |page|
    page.insert_html :bottom, :new_promotion, :partial=>"promotion", :object=> @count
    page.replace_html :promotion_link, :partial=>"promotion_link", :object=> @count
    end
  end
  def new_promotion
    @promotion=CouponCode.new
    @count=1
  end
  def update
    c=0
    @coupons=CouponCode.find(:all)
    @count=1
    @plans=PricingPlan.find(:all)
    if (params[:tier][:max_users_in_group].to_i<1001 && params[:tier][:max_users_in_group].to_i!=0 && params[:tier][:day].to_i>6) && ((params[:tier][:hours]).match /[a-z]/ ).nil? && (((params[:tier][:hours]).match /^[\d]+(\.[\d]+){0,1}$/) && ((params[:tier][:max_group]).match /^[\d]+(\.[\d]+){0,1}$/) && ((params[:tier][:max_users_in_group]).match /^[\d]+(\.[\d]+){0,1}$/ ))
             c=c+1
    else
      if (params[:tier][:max_users_in_group].to_i<1001 && params[:tier][:max_users_in_group].to_i!=0 && params[:tier][:day].to_i>6) &&(((params[:tier][:max_group]).match /^[\d]+(\.[\d]+){0,1}$/) && ((params[:tier][:max_users_in_group]).match /^[\d]+(\.[\d]+){0,1}$/ ))
        flash.now[:hours]="Entered Input was not valid" if params[:tier][:hours].blank? || !((params[:tier][:hours]).match /^[\d]+(\.[\d]+){0,1}$/)
      else
        flash.now[:error]="For FREE VERSION maximum number groups between 1 to 1000 and days of free use >7"
        flash.now[:hours]="Entered Input was not valid" if params[:tier][:hours].blank? || !((params[:tier][:hours]).match /^[\d]+(\.[\d]+){0,1}$/)
      end
    end
    for i in 1..3
      if i!=0 && !params["tier#{i.to_s}".to_sym][:is_active] 
        params["tier#{i.to_s}".to_sym][:is_active]=0
      end
      if (((params["tier#{i.to_s}".to_sym][:amount]).match /^[\d]+(\.[\d]+){0,1}$/) && ((params["tier#{i.to_s}".to_sym][:max_group]).match /^[\d]+(\.[\d]+){0,1}$/) && ((params["tier#{i.to_s}".to_sym][:max_users_in_group]).match /^[\d]+(\.[\d]+){0,1}$/ ))
        @plans[i].update_attributes(params["tier#{i.to_s}".to_sym])
        c=c+1
      else 
          if !((params["tier#{i.to_s}".to_sym][:amount]).match /^[\d]+(\.[\d]+){0,1}$/)
            flash.now["amount"+i.to_s]="Entered Input was not valid"
          end
          if !((params["tier#{i.to_s}".to_sym][:max_group]).match /^[\d]+(\.[\d]+){0,1}$/)
            flash.now["max_group"+i.to_s]="Entered Input was not valid"
          end
          if !((params["tier#{i.to_s}".to_sym][:max_users_in_group]).match /^[\d]+(\.[\d]+){0,1}$/ )
          flash.now["max_users_in_group"+i.to_s]="Entered Input was not valid"
          end
      end
    end

    if c==4  
      
      for i in 1..3
        @plans[i].update_attributes(params["tier#{i.to_s}".to_sym])
      end
     @plans[0].update_attributes(params[:tier]) 
      flash.now[:notice]= "Pricing Plan Updated" 
      render :action =>'edit'
    else
      render :action=>'edit'
    end
  end
  def coupon_update
puts "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
    @c=CouponCode.find_by_id(params[:id])
    if @c.nil?
      if !params[:promotion][:is_active]
        params[:promotion][:is_active]=0
      end
      if !(params[:promotion][:code].strip).empty? && ((params[:promotion][:code].strip).match /^[\d]+(\.[\d]+){0,1}$/)
      @coupon=CouponCode.create(params[:promotion]) 
      flash[:notice] ="Coupon Code created"
      else
        flash[:error]="Please the enter the Valid Coupon Code"
      end
    else
      if !params[:promotion][:is_active]
        params[:promotion][:is_active]=0
      end
      if @c.update_attributes(params[:promotion])
      flash[:notice] = "Coupon Code updated"
      else 
        flash[:error]= "Coupon Code not updated (code must be unique and no character allowed)"
      end
    end
    redirect_to :action=>'edit'
  end
end
