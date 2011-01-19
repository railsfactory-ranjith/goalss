class SearchsController < ApplicationController
   layout "after_login",:except=>['group_list']
   before_filter :must_be_logged_in
  def group_list
    @groups=[]
    @group_user=current_user.group_users.find(:all,:conditions=>['is_active = ? AND is_deleted = ?',true,false])
    @group_user.each do |group|
    @groups<<Group.find_by_id(group.group_id,:conditions=>['is_active = ?',true])
    end
  end
  def save_parameter
    session[:groups]=params[:groups]
    session[:location]=params[:location]
    session[:search]=params[:search]
    end
  def search_results
    grp_id=[]
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    if params[:group]||params[:locations]
      select_groups 
    end
    if params[:search]
      @search=params[:search] 
      save_parameter 
    end
    if (params[:groups].nil? && params[:location].nil? && params[:search].nil?)
      params[:groups]=session[:groups]
      params[:location]=session[:location]
      params[:search]=session[:search]
    end
    @search=params[:search]
    if (params[:all] || params[:groups]) && !params[:location] 
      all_locations(@search)
    elsif (params[:all] || params[:groups]) && params[:all_loc] 
      diff_groups(@search)
    elsif params[:groups] && !params[:all_loc]
         diff_groups(@search)
    elsif !params[:groups] && (!params[:all_loc] || params[:location])
      specific_location(@search)
    end
  end
  def all_locations(search)
    @collections=[]
    @collection=[]
    @search=params[:search]
    if params[:all] || params[:action]=="simple_search"
      @collections<<current_user.status_update_search(search)
      @collections<<current_user.group_obj_search(search)
      @collections<<current_user.message_search(search)
      refresh_result(@collections)
      else
      search_all_location(search)
    end
  end
  def specific_location(search)
    @collections=[]
    if params[:location] 
      @collections<<current_user.status_update_search(search) if params[:location][:status_update]
      @collections<<current_user.message_search(search) if params[:location][:message]
      if params[:location][:goal_obj]
        @collections<< current_user.group_obj_search(search)
      end
    elsif params[:all] 
      all_locations(search)
    elsif params[:groups]
      search_all_location(search)
    end
     refresh_result(@collections)
    objectives
      end
  def diff_groups(search)
    @collections=[]
    @search=search
    if params[:location] 
      params[:groups].each do|k,v|
      @collections<<current_user.status_update_group_search(search,v) if params[:location][:status_update]  
      @collections<<current_user.message_group_search(search,v)   if params[:location][:message]
      if params[:location][:goal_obj]
       @collections<<current_user.group_obj_search_group(search,v)
      end
      end
       refresh_result(@collections)
    else
      params[:groups].each do|k,v|
     @collections<<current_user.status_update_group_search(search,v) 
     @collections<<current_user.groups.find(:all,:conditions=>['user_id=? AND id=? AND description LIKE?',current_user.id,v,"%#{search}%"])
     @collections<<current_user.message_group_search(search,v) 
     @collections<<current_user.group_obj_search_group(search,v)
      end
      refresh_result(@collections)
    end
  end
  def search_all_location(search)
    @collections=[]
    search=params[:search]
    params[:groups].each do|k,v| 
    @collections<<current_user.status_update_group_search(search,v)    
    @collections<<current_user.group_obj_search_group(search,v)
    @collections<<current_user.message_group_search(search,v)
   end  
  refresh_result(@collections)
  end
   def objectives
    @objective=[]
    if current_user.group_users
      @groups=current_user.group_users
      @groups.each { |group| 		
      group=Group.find(group.group_id)
      pra = group.objectives.find(:all,:conditions=>['due_date >= ? AND due_date < ?',Date.today, Date.today+7])
      if !pra.empty?						
        @objective<< pra		
      end
      }
      @objective.flatten!
  end
end
def simple_search
  if !session[:filter_group].nil? && session[:filter_group]!="0"
    params[:groups]=Hash[*session[:filter_group].collect{|v|[v,v]}.flatten]
  end
  session[:search]=params[:search] if params[:search]
  params[:search]=session[:search] if !params[:search]
  @search=params[:search]
  @favorites=Favorite.find_all_by_user_id(current_user.id)
  @collections=[]
  if (!params[:location] || params[:all_loc]) && session[:filter_group].nil?
    all_locations(@search)
  elsif params[:location] && session[:filter_group].nil?
    specific_location(@search)
  elsif (!params[:location] || params[:all_loc]) && !session[:filter_group].nil?
    search_all_location(@search)
  elsif params[:location] && !session[:filter_group].nil?
    diff_groups(@search)
  end
  render :action=>"search_results"
  end
end
def refresh_result(collection)
  @objective=[]
  if params[:groups] && !params[:all] && params[:footer]!="no"
    params[:groups].each do|k,v|
      @group=Group.find_by_id(v)
      @objective<<@group.group_upcoming_objectives
    end
    @objective.flatten!
  else
    objectives
  end
  @groups=current_user.group_users
  @collections_pagin=collection.uniq.flatten!
  if !@collections_pagin.nil?
    @collection=(@collections_pagin.sort_by {|collection| collection.updated_at}).reverse
    @collection.uniq!
    @collection=@collection.paginate(:page=>params[:page],:per_page=>10)
  end
  if request.xml_http_request?
    render :update do |page|      
      page.replace_html "group_bgc",:partial=>'results'
      page.replace_html "stat_field",:partial=>'group_activities/status_update'
      page.replace_html "search_footer",:partial=>'footer_search'
    end
  end
end
    