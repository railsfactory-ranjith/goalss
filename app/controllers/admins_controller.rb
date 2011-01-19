require 'authenticated_system.rb'
 require 'user_authenticated_system.rb'
class AdminsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #before_filter :login_required ,:only=>['change_password','new','csr_dashboard','manager_dashboard']
  include AuthenticatedSystem
  before_filter :must_be_admin_user_logged_in, :except=>['reset_password','forgot_password']
  layout :change_layout, :except=>['change_password']
  # render new.rhtml
  def new
    @groups=Group.find(:all) 
    # @groups =  Group.paginate(:all,:page => params[:page],:per_page =>2,:order => "id desc")
    params[:order] = "created_at DESC"
    groups_pages = @groups.length 
    if groups_pages % ENTRIES_PER_PAGE ==0
      groups_pages=groups_pages / ENTRIES_PER_PAGE
    else
      groups_pages=groups_pages/ ENTRIES_PER_PAGE+1
    end
    if params[:page].to_i > groups_pages.to_i
      @groups = Group.all.paginate :page => 1, :per_page => ENTRIES_PER_PAGE,:order => 'created_at DESC'           
    elsif params[:page].to_i == 0
      @groups = Group.all.paginate :page =>1, :per_page =>ENTRIES_PER_PAGE,:order => 'created_at DESC'           
    else
      @groups = Group.all.paginate :page =>params[:page], :per_page => ENTRIES_PER_PAGE,:order => 'created_at DESC'           
    end 
  end
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @admin = Admin.new(params[:admin])
    @admin.save
    if @admin.errors.empty?
      self.current_admin = @admin
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  def forgot_password
    return unless request.post?
		if @admin = Admin.find_by_email(params[:admin][:email])
      @admin.forgot_password
      @admin.save
			AdminMailer.deliver_forgot_password(@admin) 
			flash[:notice] = "A password reset link has been sent to your email address" 
      redirect_back_or_default('/admin')
    else
      flash[:error] = "Could not find a user with that email address" 
			redirect_back_or_default('/forgot_password')
		end
  end
  def reset_password
	  @admin = Admin.find_by_password_reset_code(params[:id])
    return if @admin unless params[:admin]
    if ((params[:admin][:password] && params[:admin][:password_confirmation]) && (!params[:admin][:password].blank? && !params[:admin][:password_confirmation].blank?))
      if (params[:admin][:password] == params[:admin][:password_confirmation])
        self.current_admin = @admin #for the next two lines to work
        current_admin.password_confirmation = params[:admin][:password_confirmation]
        current_admin.password = params[:admin][:password]
        @admin.reset_password
        if current_admin.save
          flash[:notice] ="Password reset success"
          redirect_back_or_default('/admin')
        end	
      else
        flash.now[:error] = "Password doesn't match confirmation" 
      end  
    else
      flash.now[:error] = "Password & confirmation password should not be blank" 
    end  
  end
	def change_password
    @csr= Admin.find(params[:id])
  end
  def csr_dashboard
    @groups=Group.paginate :order =>params[:order], :page=>params[:page],:per_page=>ENTRIES_PER_PAGE
	end
  def manager_dashboard
    @group=Group.find(:all)
    if params[:order]== "first_name" || params[:order]=="first_name DESC"
      @user=User.find_all_by_id(@group.collect{|u| u.user_id},:order=>"user_profiles.#{params[:order]}",:include=>:user_profile)
      sorted
    elsif params[:order]=="group_leader_id" 
      @user=User.find_all_by_id(@group.collect{|u| u.group_leader_id},:order=>"user_profiles.first_name",:include=>:user_profile)
      sorted
    elsif params[:order]=="group_leader_id DESC"
      @user=User.find_all_by_id(@group.collect{|u| u.group_leader_id},:order=>"user_profiles.first_name DESC",:include=>:user_profile)
      sorted
    else
      @groups=Group.all.paginate :order =>params[:order], :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
    end
      if request.xml_http_request?
      render :update do |page|      
      page.replace_html "group",:partial=>'manager_dashboard'
      end                        
    end
  end
  def activate
    self.current_admin = params[:activation_code].blank? ? false : Admin.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_admin.active?
      current_admin.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end
  def change_layout
    if action_name=="forgot_password" || action_name=="reset_password"
      "before_login"
    else 
       "admin_login"
    end   
  end  
  def export_excel
  @groups=Group.find(:all)
   respond_to do |format|
   format.html
   format.xml { render :xml => @groups }
   format.xls { send_data @groups.to_xls(:only =>[:name,:user_id,:group_leader_id,:created_at,:is_active],:headers=>false)}
end

end
def sorted
  @grou=[]
  @user.each do|user|
    @grou<< Group.find(:all,:conditions=>['user_id=?',user.id])
  end
  @grou.flatten!
  @groups=@grou.paginate :page=>params[:page],:per_page=>ENTRIES_PER_PAGE 
  end
end
