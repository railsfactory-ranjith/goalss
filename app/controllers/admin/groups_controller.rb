
class Admin::GroupsController < AdminsController
  layout "admin_login",:except=>['group_edit']
  def group_details
    @group=Group.find(params[:id])
    if !@group.group_leader_id.nil?
      @group_leader=UserProfile.find(@group.group_leader_id)
      else
        @group_leader=@group.user.user_profile
    end
    unless @group.user.is_free_user
      @response=creditcard_gateway.get_profile_details(@group.user.user_creditcard.recurring_profile_id)   
      @outstanding_balance=@response.params["outstanding_balance"].to_f.abs
    end      
  end
  
  def group_update
    @group=Group.find(params[:id])
    if !@group.group_leader_id.nil?
      @group_leader=UserProfile.find(@group.group_leader_id)
      else
      @group_leader=@group.user.user_profile
    end
  end
  def group_edit
    @group=Group.find(params[:id])
    @users=User.find(:all,:conditions=>['state is NULL'])
  end
  def change_status
   @group=Group.find(params[:id])
    if params[:activegroup]
      @group.update_attributes(:is_active=>true)
      @log=AdminLog.new(:admin_id=>current_admin.id,:comment=>"Activated #{@group.name } ",:group_id=>@group.id)
      @log.save
      flash[:notice]="Group is activated"
    else
      @group.update_attributes(:is_active=>false)
      @log=AdminLog.new(:admin_id=>current_admin.id,:comment=>"Suspended #{@group.name}",:group_id=>@group.id)
      @log.save
      flash[:notice]="Group is suspended"
    end
    redirect_to :action=>'group_update',:id=>params[:id]
  end
  def change_leader
    @group=Group.find(params[:id])
    #@c=User.find_by_id(params[:user][:userprofile_id]).user_profile.first_name
    @group.update_attributes(:group_leader_id=>params[:user][:userprofile_id])
    @group_leader=UserProfile.find(@group.group_leader_id)
    @log=AdminLog.new(:admin_id=>current_admin.id,:comment=>"Leader changed for #{@group.name}",:group_id=>@group.id)
    @log.save
    render :update do |page|
      flash[:notice]="Leader is changed"
      page.redirect_to :action=>'group_update' ,:id=> @group.id
    end
  end
  def invite_leader
    @group=Group.find(params[:id])
    if (!params[:group][:leader_email_invite].empty?) && ((params[:group][:leader_email_invite]).match /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i )
      @group.update_attributes(params[:group])
      @group.update_attributes(:invited_at=>Time.now)
      code=Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
      @group.update_attributes(:invitation_code=>code,:invited_at=>Time.now)
      AdminMailer.deliver_change_leader(@group,code)
      @log=AdminLog.new(:admin_id=>current_admin.id,:comment=>"Leader invited for #{@group.name}",:group_id=>@group.id)
      @log.save
      flash[:notice]="New Leader is invited"
      render :update do |page|
        page.redirect_to :action=>'group_update' ,:id=> @group.id
      end
    else
      render :update do |page| 
        page.replace_html "errorpop","please enter the valid email id"
      end
    end
  end
end

