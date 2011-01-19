# This controller handles the login/logout function of the site.  
require 'authenticated_system.rb'
 require 'user_authenticated_system.rb'
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include UserAuthenticatedSystem
layout "before_login"
  # render new.rhtml
  def new
     #~ if current_user 
      #~ redirect_to :controller=>"users",:action=>"edit",:id=>current_user.id
    #~ end
  end

  def create 
    if params[:user][:email]!=""&& params[:user][:password] !=""
      @u = User.find_by_email(params[:user][:email], params[:user][:password])
          self.current_user = @u if @u
       if @u && user_logged_in?
        if current_user.is_free_user== true
          free_user_groups_check
        end
        if params[:remember_me] == "1"
          current_user.remember_me unless current_user.remember_token?
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        flash.now[:notice] = "Logged in successfully"

	 
        if session[:invited_member] && session[:invited_member].email==current_user.email
          redirect_to :controller=>"group_activities",:action=>"add_group_member",:id=>session[:invited_member].group_id
          session[:invited_member]=nil
        elsif session[:invited_leader] && session[:invited_leader].leader_email_invite==current_user.email
          redirect_to :controller=>"group_activities",:action=>"add_group_leader",:id=>session[:invited_leader].id
          session[:invited_leader]=nil
         elsif session[:facebook_invite_group_id]  
           redirect_to :controller=>"group_activities",:action=>"add_group_member",:id=>session[:facebook_invite_group_id]
            session[:facebook_invite_group_id]=nil  
        else
	#if @u
           redirect_to :controller=>"activities",:action=>"index"
	 end
      else
        flash.now[:error] ="There was a problem with your email address and/or password. Please try again."
        render :action => 'new'
     end
    else
      flash.now[:error] ="Email cannot be blank" if params[:user][:email].blank?
      flash.now[:error] ="Password cannot be blank" if params[:user][:password].blank?
      flash.now[:error] ="Email/password cannot be blank"  if params[:user][:email].blank? && params[:user][:password].blank?
      render :action => 'new' 
    end     
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
 end
 def free_user_groups_check
   @plan= PricingPlan.find(1)
   @groups_collection =current_user.groups
   @groups_collection.each do |group_collection|
   days=(Time.now-group_collection.created_at)/86400
   if days > @plan.day
         group_collection.update_attributes(:is_active=>0)
    end
     end
   end
end
