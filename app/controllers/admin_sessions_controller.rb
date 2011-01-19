# This controller handles the login/logout function of the site.  
require 'authenticated_system.rb'
 require 'user_authenticated_system.rb'
class AdminSessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout "before_login"
  # render new.rhtml
  def new
	end
  def create
    self.current_admin = Admin.authenticate(params[:admin][:email], params[:admin][:password])
    session[:admin_user] = true
		if self.current_admin
            session[:admin_user] = true
      if params[:remember_me] == "1"
        current_admin.remember_me unless current_admin.remember_token?
        cookies[:auth_token] = { :value => self.current_admin.remember_token , :expires => self.current_admin.remember_token_expires_at }
			end
      if current_admin.is_manager==true
        flash[:notice] = "Logged in successfully"
        redirect_back_or_default('/manager_dashboard')
			else
        if current_admin.state=="active"
          flash.now[:notice] = "Logged in successfully"
          redirect_back_or_default('/csr_dashboard')
        else
          flash.now[:error] ="Your account has been suspended"
          render :action => 'new'
        end
      end
    else
		  if (!params[:admin][:email].blank? && !params[:admin][:password].blank?)	
			  flash[:error] = "There was a problem with your email address and/or password. Please try again"	
        render :action => 'new'
      else		
			  flash[:error] = "Email/password cannot be blank"
        render :action => 'new'
			end		
    end
  end
  def destroy
    self.current_admin.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/admin')
  end
end
