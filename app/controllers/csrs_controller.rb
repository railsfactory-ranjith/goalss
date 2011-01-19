class CsrsController < ApplicationController
  layout "admin_login",:except=>['group_edit']
  before_filter :must_be_admin_user_logged_in,:only=>['create', 'list']
	def new
	end
  def create
    params[:csr][:is_active]=true
		params[:csr][:is_manager]=false
		params[:csr][:state]="active"
		puts "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
		@csr=Admin.create!(params[:csr])
		
		if	@csr.save
			puts "ggggggggggggggggggggggggggggggggggggg"
			AdminMailer.deliver_new_csr(params[:csr][:email],params[:csr][:password],params[:csr][:firstname]) 
			flash[:notice] = 'New CSR is successfully added.'
			redirect_to :action=>'list'
		else
			render :action=>"new"
		end
	end
  def list
    #@csrs=Admin.find(:all,:conditions=>['is_manager=0'])
    @csrs=Admin.all.paginate(:conditions=>['is_manager=0'],:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
  end
  def show
  end
  def destroy

  end
  def csr_sort
    #@csrs=Admin.find(:all,:conditions=>['is_manager=0'],:order=>params[:order])
    @csrs=Admin.all.paginate(:conditions=>['is_manager=0'],:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    if request.xml_http_request?
      render :update do |page|      
      page.replace_html "csr",:partial=>'csr_sort'
      end                        
    end
  end
  def edit
    @csr= Admin.find(params[:id])
		if !params[:csr] && params[:password_confirmation]
		  if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        @csr.password_confirmation = params[:password_confirmation]
        @csr.password = params[:password]
        if @csr.save
           flash.now[:notice] = "Password successfully updated" 
           AdminMailer.deliver_change_password(@csr) 
        else
          flash.now[:error] = "password and confirmation password is too short"
        end
      else
			  if (params[:password] !=params[:password_confirmation])
					flash[:error] = "New password and confirmation password mismatch" 
          redirect_to :controller => 'csrs',:action => 'edit',:id => @csr.id
        else
          flash.now[:error]="New password and confirmation password should not blank"
        end
  		end
    end
	end
	def update 
    @csr= Admin.find(params[:id])
		if @csr.update_attributes(:firstname=>params[:csr][:firstname],:lastname=>params[:csr][:lastname],:email=>params[:csr][:email])
	    flash.now[:notice] = 'CSR information was successfully updated.'
    else
      flash.now[:error] ='CSR information was not updated'
    end		
  render :action=>'edit',:id=>@csr.id    
  end
  def change_status
    @csr = Admin.find(params[:id])
    if params[:suspend]== nil
      @csr.update_attributes(:state=>"active")
      flash[:notice] = 'CSR Status is changed'
	    redirect_to :action=>'edit',:id=>@csr.id
    else
      @csr.update_attributes(:state=>"suspend")
      flash[:notice] = 'CSR Status is changed'
      redirect_to :action=>'edit',:id=>@csr.id
    end
  end
  def activity_log
    if current_admin.id==1
    @logs=AdminLog.all.paginate(:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    else
      @logs=AdminLog.all.paginate(:conditions=>['admin_id = ?',current_admin.id],:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    end
  end
  def view_log_group
      groups_id=params[:id]
    @logs=AdminLog.all.paginate(:conditions =>['group_id = ?',groups_id],:order=>params[:order],:page=>params[:page],:per_page=>ENTRIES_PER_PAGE)
    render :action=>'activity_log'
  end
end
