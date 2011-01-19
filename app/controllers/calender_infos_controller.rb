class CalenderInfosController < ApplicationController
	layout 'after_login',:except=>['calendar_foot']
	def index		
    session[:filter_group]=nil if params[:filter]
    @favorites=current_user.favorites
    if params[:hidden_date_selector]			
      hidden_date_selector_call			
    else	
      @month = Date.today.month
      @year = Date.today.year
    end
    if session[:filter_group]
      params[:group_id]= session[:filter_group]
      calculating_objectives1
    else
      calculating_objectives
    end
	end
  def group_move
    @favorites=current_user.favorites
    if params[:hidden_date_selector]
			d1 = params[:hidden_date_selector].split(" ")
      for i in 1..Date::MONTHNAMES.length
        if Date::MONTHNAMES[i] ==  d1[0]
          @month = i
        end	
      end 	 
			@year = d1[2].to_i
			d=Date.new(@year,@month,d1[1].split(",")[0].to_i)
    else
      d = Date.new(params[:year].to_i,params[:month].to_i,1)
    end
    @month = d.month
    @year = d.year
    session[:filter_group]=params[:group_id] if params[:group_id]
    calculating_objectives1
    render :action => :index
  end  
  def move_week
	  if params[:hidden_date_selector]
			d1 = params[:hidden_date_selector].split(" ")
      for i in 1..Date::MONTHNAMES.length
			  if Date::MONTHNAMES[i] ==  d1[0]
          @month = i
        end	
      end 	 
			@year = d1[2].to_i
			d=Date.new(@year,@month,d1[1].split(",")[0].to_i)
    else	
      if params[:left]
        if params[:prev]=="0"
          d = Date.new(params[:year].to_i,params[:month].to_i,1)-1
        else
          d = Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i)-1
        end	 
      elsif params[:right]
        if params[:next]=="0"
          d = Date.new(params[:year].to_i,params[:month].to_i,1).next_month
        else
          d = Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i)+1				
        end	
      end	
    end
	  @begin_w =  d.beginning_of_week
	  @end_w =  d.end_of_week	 
	  @month =  d.month
	  @year =  d.year
	  session[:filter_group] ? calculating_week_details1 : calculating_week_details
	  render :action => :week
	end     
	def move_month
    @favorites=Favorite.find_all_by_user_id(current_user.id) 
	  if 	params[:hidden_date_selector]
			hidden_date_selector_call
    else	
			d = Date.new(params[:year].to_i,params[:month].to_i,1)
			if params[:right]
				d= d.next_month
			elsif params[:left]
				d= d.last_month								
			end		
			@month = d.month
			@year = d.year				
		end	
    session[:filter_group] ? calculating_objectives1 : calculating_objectives
		render :action => :index
	end	
	def move_group
    @groups =[]
		@objectives =[]				
			g =[]
			obj =[]
			current_user.active_group_membership.each { |coll| 		
	    pra = coll.group.objectives.find_all_by_due_date(Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i)) if coll.group.is_active==true	 
	    if !pra.nil? && !pra.empty?						
				g << coll.group
				obj << pra				
	    end	 							
				}				
		@groups = g.flatten.uniq
		@objectives= obj.flatten.uniq		
		if @groups.length >5
			@groups = @groups[0..4]
		end	
		@group = params[:group_id]
		@objective = Objective.find_by_group_id_and_due_date(@group,Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i))
		render :layout => false		
	end	
	def more_info		
    @favorites=Favorite.find_all_by_user_id(current_user.id)
		#~ @objectives = Objective.find_all_by_due_date(Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i))
    @objectives = current_user.objectives_on_duedate(params[:year].to_i,params[:month].to_i,params[:date].to_i,session[:filter_group])
		render :layout => false		
	end	
	def move_day
    @favorites=Favorite.find_all_by_user_id(current_user.id)
  	d = Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i)
		if params[:left]
			d =d -1
		elsif params[:right]
			d=d+1
		end	
		params[:year] = d.year
		params[:month] = d.month
		params[:date]=d.day
    group=current_user.active_group_membership
		@objectives = Objective.find_all_by_due_date(Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i),:conditions=>{'group_id'=>group.collect{|x| x.group_id},'groups.is_active'=>1},:include=>:group)
    render :update do |page|		
				page.replace "lightbox_div", :partial => 'move_day'
		end	
	end	
	def calculating_objectives
    @favorites=current_user.favorites
		tot = Time::days_in_month(@month,@year)
		@group = nil
		@groups =[]
		@objectives =[]		
    pra=[]
    current_user.group_active_membership.each { |coll| 		
        pra << coll.group.objectives
     }
    pra.flatten!
    if !pra.blank? && !pra.nil?
      for  d in 1..tot			
        g =[]
        obj =[]
        pra.each do |pra1| 		
          if !pra1.due_date.nil?
            if pra1.due_date.strftime("%Y-%m-%d") == Date.new(@year,@month,d).to_s
              g << pra1.group
              obj << pra				
            end	 	
          end        
        end					
        @groups[d] = g.flatten.uniq
        @objectives[d] = obj.flatten.uniq
        if @groups[d].length >5
          @groups[d] = @groups[d][0..4]
        end	
      end
    end
  end	
	def week	
    session[:filter_group]=nil if params[:filter]
    @favorites=Favorite.find_all_by_user_id(current_user.id)
		d= Date.today
	  if params[:hidden_date_selector]
			d1 = params[:hidden_date_selector].split(" ")
      for i in 1..Date::MONTHNAMES.length
			  if Date::MONTHNAMES[i] ==  d1[0]
          @month = i
				end	
      end 	 
			@year = d1[2].to_i
			d=Date.new(@year,@month,d1[1].split(",")[0].to_i)
    end					
		@begin_w = d.beginning_of_week
	  @end_w = d.end_of_week	 
	  @month = d.month
	  @year = d.year
    if session[:filter_group]
      params[:group_id]=session[:filter_group]
      calculating_week_details1
    else
      calculating_week_details
    end
  end
 
 def group_week
    @favorites=Favorite.find_all_by_user_id(current_user.id) 
   	if params[:hidden_date_selector]
			d1 = params[:hidden_date_selector].split(" ")
      for i in 1..Date::MONTHNAMES.length
        if Date::MONTHNAMES[i] ==  d1[0]
          @month = i
        end	
      end 	 
			@year = d1[2].to_i
			d=Date.new(@year,@month,d1[1].split(",")[0].to_i)
		else	
      d = Date.new(params[:year].to_i,params[:month].to_i,params[:date].to_i)				
    end
    @begin_w =  d.beginning_of_week
    @end_w =  d.end_of_week	 
    @month =  d.month
    @year =  d.year
    calculating_week_details1	 
    render :action => :week
 end  
  def calculating_week_details
    @favorites=Favorite.find_all_by_user_id(current_user.id)
    @week_details = []		
    @group=nil
	  for i in 0..6
      cur = @begin_w+i
      if @begin_w.month != @month 
        @prev= 0;@next =1
      elsif @end_w.month != @month
        @prev= 1;@next =0
      end	 
		  if cur.month ==  @month && !current_user.active_group_membership.empty?
        a = []
        current_user.active_group_membership.each { |coll| 	
        a << coll.group.objectives.find_all_by_due_date(cur) if coll.group.is_active==true
        } 
        @week_details[i] = a.flatten.uniq            
      else 
        @week_details[i]=[]
      end	 
		end
  end	
	def calculating_week_details1
    @favorites=Favorite.find_all_by_user_id(current_user.id) 
    @week_details = []	
    session[:filter_group]=params[:group_id] if params[:group_id]
    @group = Group.find_by_id(session[:filter_group])
	  for i in 0..6
	    cur = @begin_w+i
      if @begin_w.month != @month 
		    @prev= 0;@next =1
		  elsif @end_w.month != @month
		    @prev= 1;@next =0
      end	 
      k=false
      group = Group.find_by_id(session[:filter_group])
      current_user.active_group_membership.each{|coll|
      if coll.group_id==group.id && group.is_active==true
        k=true
      end
        }
      if cur.month ==  @month && k
    	  @week_details[i] = Objective.find_all_by_due_date_and_group_id(cur,session[:filter_group],:conditions=>['groups.is_active=?',1],:include=>:group)   
      else 
        @week_details[i]=[]
      end	 
		end
  end		
  def hidden_date_selector_call
	  d = params[:hidden_date_selector].split(" ")
		for i in 1..Date::MONTHNAMES.length
		  if Date::MONTHNAMES[i] ==  d[0]
        @month = i
      end	
    end 	 
		@year = d[2].to_i		
  end	
  def calculating_objectives1
    @favorites=Favorite.find_all_by_user_id(current_user.id) 
		tot = Time::days_in_month(@month,@year)
    session[:filter_group]=params[:group_id] if params[:group_id]
		@group = Group.find_by_id(session[:filter_group])
		@groups =[]
		@objectives =[]		
    group = Group.find_by_id(session[:filter_group])
    pra=[]
    pra=group.objectives if @group.is_active?
  if !pra.empty?
      for  d in 1..tot			
        g =[]
        obj =[]
        pra.each do |pra1| 		
          if !pra1.due_date.nil?
          if pra1.due_date.strftime("%Y-%m-%d") == Date.new(@year,@month,d).to_s
            g << pra1.group
            obj << pra				
          end	 	
          end        
        end					
        @groups[d] = g.flatten.uniq
        @objectives[d] = obj.flatten.uniq
        if @groups[d].length >5
          @groups[d] = @groups[d][0..4]
        end	
      end
    end
   end    
	def calendar_foot
    @favorites=current_user.favorites
    @groups=current_user.group_membership
    if !params[:date].nil?
      @day=params[:date]
    end
    @month = Date.today.month
    @year = Date.today.year
  end
end
