class AccessCodesController < ApplicationController
    layout "admin_login"
  def edit
    @access_codes=AccessCode.find(:all)
    @count=1
  end
  def generate_code
    @count=params[:count] if params[:count]
    render :update do |page|
        page.replace_html :access_code, :partial=>"access_code",:object=> @count 
        page.insert_html :bottom, :new_access_code, :partial=>"generate_code",:object=> @count
    end
  end
  
  def update
  if !params[:cancel]
  old=AccessCode.find(:all).count
   k=true
    for i in 1..(params[:access].length)
      if  (params[:access]["access"+i.to_s]["code"+i.to_s]).blank? ||  (params[:access]["access"+i.to_s]["code"+i.to_s]).nil?
        k=false
      end
    end
    if k
      for i in 1..(params[:access].length) 
            if i<=old
              @access_code=AccessCode.find(i)
              @access_code.update_attribute(:access_code,(params[:access]["access"+i.to_s]["code"+i.to_s].strip))
              params[:access]["access"+i.to_s]["is_active"+i.to_s] ? @access_code.update_attribute(:is_active,1) :@access_code.update_attribute(:is_active,0)
              a="Access code Updated"
            else
              @access_code=AccessCode.new
              @access_code.access_code=params[:access]["access"+i.to_s]["code"+i.to_s].strip
              @access_code.is_active=1 if params[:access]["access"+i.to_s]["is_active"+i.to_s]
              @access_code.save
              b="Access Code created"
            end
      
      end
      flash[:notice]="Access Code Updated"
      redirect_to :action=>'edit'
    else

      flash.now[:error]="Please Enter the valid Access Code"
      #flash[:notice]=a if !a.nil?
      #flash[:notice1]=b if !b.nil?
      #flash[:notice]="Access Code Updated" if k==1
      #@count=params[:access].length
      @access_codes=AccessCode.find(:all)
      render :action=>'edit'
    end
    else
      redirect_to :action=>'edit'
      end
  end
end
