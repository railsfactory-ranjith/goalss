class BetasignupsController < ApplicationController
  layout "before_login"
  def create
      @access_codes=AccessCode.find(:first,:conditions=>['access_code=? && is_active=?',"#{params[:user][:access_code].strip}",true])
      if !@access_codes.nil? &&  !((params[:user][:email_check]).match  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).nil?
        session[:access_code]=@access_codes.access_code
      redirect_to :controller=>"users",:action=>"new" 
      else
        flash[:notice]="click on view invitation for getting the new request"
        if params[:user][:access_code]==""
        flash[:access]="can't be blank"
         elsif  @access_codes.nil?       
        flash[:access]="Invalid code" 
      end
      if params[:user][:email_check] == ""
        flash[:email_blank]="can't be blank" 
        elsif ((params[:user][:email_check]).match  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).nil?
        flash[:email_blank]="Invalid email" 
        end
        render :action=>"signup_beta"
      end
    end
    def invit_request
      @beta_invit=BetaInvit.new(params[:beta_invit])
      @beta_invit.dob= convert_date(params[:date]) if !params[:date][:month].empty? && !params[:date][:day].empty? && !params[:date][:year].empty?
      if @beta_invit.valid?
        @beta_invit.save 
        flash[:notice] = "Your request for access has been submitted. We will do our best to provide you with access, but not all requests for an invitation can be honored"
        self.current_user=nil
        redirect_to :controller=>"users", :action=>"account_created"
      else
        render :action=>"signup_beta"
      end          
    end
  def export_excel_invit_req
  @beta_invit=BetaInvit.find(:all)
  respond_to do |format|
   format.html
   format.xml { render :xml => @beta_invit }
   format.xls { send_data @beta_invit.to_invite_user_xls(:only=>[:id,:email,:first_name,:last_name,:organization,:occupation,:country,:zipcode ,:dob,:referred_by,:invitation_msg,:created_at]) }
  end
end
def export_excel_regist_user
  @users=User.find(:all)
  respond_to do |format|
   format.html
   format.xml { render :xml => @users }
  format.xls { send_data @users.to_register_user_xls(:only =>[:id,:email,:is_free_user,:created_at,:access_code])}
end
end  
def signup_beta
  end
end
