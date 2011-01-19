require 'facebooker'

class FbhomeController < ApplicationController
    layout "after_login"
  before_filter :initialize_keys

  def index
    session[:s_key]=nil
    session[:uid]=nil
    if session[:s_key] || session[:uid]
      @session = "Your existing session still alive. Please clear your local sessions and cookies before running"
    end
  end

  def getstart
       session[:s_key]=nil
    session[:uid]=nil
    if session[:s_key] || session[:uid]
      @session = "Your existing session still alive. Please clear your local sessions and cookies before running"
    end
    #@exist_accounts = FbSession.find(:all, :conditions=>["local_session_id=? and fb_session_key IS NOT NULL and fb_user_name IS NOT NULL",session.session_id])
    @exist_accounts = FbSession.find(:all, :conditions=>["user_id=? and fb_session_key IS NOT NULL and fb_user_name IS NOT NULL",current_user.id])
  end

  def get_session
    user_token = params[:user_token]
    begin
      fb_session = Facebooker::Session.create(@api_key, @secret_key)
      @session_hash = fb_session.post "facebook.auth.getSession", :auth_token => user_token      
      session[:s_key] = @session_hash['session_key']
      session[:uid] = @session_hash['uid']      
      @user_info = fb_session.post("facebook.users.getInfo",:uids=>session[:uid],:fields=>'name')
      @info = @user_info[0]      
      session[:uname] = @info['name']
      fb_session = FbSession.find_by_uid(@session_hash['uid'])
      fb_session = fb_session ? fb_session : FbSession.new
      fb_session.update_attributes(:uid=>@session_hash['uid'], :local_session_id=> session.session_id, :fb_session_key=>@session_hash['session_key'], :fb_user_token=> user_token, :fb_user_name=>@info['name'],:user_id=>current_user.id)
    rescue      
      flash.now[:error_notice] = "Sorry, Invalid code."
      render :action=>'getstart'
    end
  end

  def create_test_session
    if params[:id] && params[:id].length>0
     fb_session = FbSession.find(params[:id])
     session[:s_key]=fb_session.fb_session_key
     session[:uid]=fb_session.uid
     session[:uname]=fb_session.fb_user_name
    end
  end

  def post_message
    begin
  
      @inv=Invitation.new
   code=Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
          @inv.group_id=session[:group_invite]
          @inv.user_id=current_user.id
           @inv.invitation_code=code
           @inv.message=params[:msg]
          @inv.save
      msg = params[:msg] +"  please visit #{$SITE_URL}invite/#{@inv.invitation_code}"
      fb_session = Facebooker::Session.create(@api_key, @secret_key)
      post_msg = fb_session.post("facebook.stream.publish",:message=>"#{msg}", :session_key=>session[:s_key], :target_id=>session[:uid])
      post_msg = post_msg.gsub("_","")
      @user_detail = FbSession.find_by_uid(session[:uid])
      session[:facebook_message]=msg
      msg = post_msg.match(/^\d+$/) ? (render :action=> 'user_details') : (render :text=> "<font color='red'>Unable to post message on facebook wall.</font>")
    rescue
      flash.now[:error_post_notice] = "Sorry, Your account is not added with our system. Please follow the below steps."
      render :action=>'get_session'
    end   
  end

  def user_details
     
    
  end


  def initialize_keys
    @api_key = APP_CONFIG[:fb_api_key]
    @secret_key = APP_CONFIG[:fb_secret_key]
    @code_gen = "http://www.facebook.com/code_gen.php?v=1.0&api_key=#{@api_key}"
    @allow_system = "http://www.facebook.com/authorize.php?api_key=#{@api_key}&v=1.0&ext_perm=publish_stream "
  end

  
end

