class StaticpagesController < ApplicationController
    #layout "before_login"
    layout :change_layout_static
  def index
    @pages=StaticPage.find :all
  end    

  def edit
    @static_page=StaticPage.find_by_id(params[:id])
  end    
     
  def update
    @static=StaticPage.find_by_id(params[:id])
    @static.update_attributes(:title=>params[:static_page][:title], :page_center=>params[:static_page][:page_center])
    flash[:notice]="Successfully Updated"
    redirect_to :action=>"index"
  end 

  def show
    @page = StaticPage.find_by_name(params[:name])
    if @page
      render :template=>"/staticpages/#{@page.name}",:layout=>'staticpage'
      return
    else
      #render :text => 'Page not found'
     # redirect_to show_url
      return
    end
   end   


def debug_session
   render :text=>session.inspect 
end    
 def features
 end
 def privacy
 end
 def about_us
   
 end
 def support
 end
 def terms_cond
   end
def change_layout_static
  if current_admin
    "admin_login"
  elsif current_user
    "after_login"  
  else
    "before_login"
  end
end

end
