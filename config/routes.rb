Goals::Application.routes.draw do
 root :to=> 'sessions#new'
  resources :admins


  resource :admin_session, :only => [:new, :create, :destroy]

  match 'signup' => 'admins#new', :as => :signup

  match 'register' => 'admins#create', :as => :register

  match 'login' => 'admin_sessions#new', :as => :login

  match 'logout' => 'admin_sessions#destroy', :as => :logout

  match '/activate/:activation_code' => 'admins#activate', :as => :activate, :activation_code => nil

  
  
  resources :searchs do
	  collection do
		  post :group_list
		  get :search_results 
		  get :simple_search
	  end
  end
  
  resources :users do
	  member do
		  get :discontinue
		  get :profile_thirdparty
		  get :thirdparty_activit
		  post :post_user_comment
	  end
	  collection do
	 get :list_filter
	 get :settings
	 put :settings_update
	 get :check_user_account
	 get :upload_file
	 get :account_created
	 get :unauthorized
	 get :favorite_user_group
 end
 end
	  

  resource :session, :only => [:new, :create, :destroy]

  match 'signup' => 'users#new', :as => :signup
match 'account_created' => 'users#account_created', :as => :account_created

  match 'register' => 'users#create', :as => :register

  match 'login' => 'sessions#new', :as => :login

  match 'logout' => 'sessions#destroy', :as => :logout

  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil


match '/session' => "users#edit"

resources :calender_infos do
   collection do
	  get :list_filter
	  get :settings
	  put :settings_update
	  get :check_user_account
	  get :upload_file
	  get :account_created
	  get :unauthorized
	   get :favorite_user_group
   end
   member do
	    get :discontinue
	     get :profile_thirdparty
	      get :thirdparty_activity
		post:post_user_comment
   end
   end
  resources :staticpages do
	 post :index, :on=> :collection
  end

 resources :groups do
   collection do
	  get :more_footer
	  get :objectives
	  post :invite_contact
	  get :display_contacts
	  post :invite
	  post :send_invitation
	  get :review_group
	   get :list
	   get :footer_dashboard
	   get :add_direct_contacts
   end
 member do
	    get :edit_objectives
	     put :update_review
	      post :final_contacts
		post:finish_group
		get :edit_invited_members
		put :update_invited_members
		get :finish
		get :checking
		get :review_edit_group
		get :review_edit_objectives
	end
  end
   resources :pricing_controls do
	   collection do
		   get :promotions
		   end
	
 end
  #map.promotions '/promotions/:id' ,:controller => "pricing_controls",:action => "promotion", :method=>"get"
#~ s {:action=>"pay_bill", :plan=>1, :coupon_code=>nil, :controller=>"paid_users"})
#paid_users/pay_bill?coupon_code=123&plan=2

  
  match 'check_user_account' => 'users#check_user_account', :as => :check_user_account_users 
match '/pricing_controls_promotions' =>"pricing_controls#promotions",:as=>:pricing_controls_promotions
match 'add_plan' => 'paid_users#add_plan', :as => :add_plan_paid_users 
   # match '/pay_bill/:coupon_code/:plan' => 'paid_users#paybill', :as => :add_plan_paid_users 
#No route matches {:action=>"add_plan", :controller=>"paid_users"}
  resources :group_updates do
  collection do
	  get :change_paid_user
	  get :send_leader_mail
	  get :older_post
	  get :save_user_detail
	  get :new_group_update
	 end
   end
 resources :calender_infos do
  collection do
	  get :week
	  get :move_month
	  get :move_group
	  get :more_info
	   end
   end
   resources :betasignups do
  collection do
	  get :export_excel_regist_user
	  get :signup_beta
	  get :invit_request
	  get :export_excel_invit_req
		 end
   end
  resources :activities do
  collection do
	  get :upload_file
	  get :my_older_post_group
	  get :older_post_group
	  get :send_leader_mail
	  get :older_post
	  get :my_activities
	  get :my_older_post
	  get :my_activity_send_leader_mail
	  get :footer
	  get :footer_myactivity
	  post :new_create
	   get :decline_inv
	  get :new_updates
	  get :download_file
	    
	 end
 end
 match '/new' => 'groups#new', :as =>:new_groups
match '/invite_members/:id' => 'groups#invite_members', :as =>:invite_members
match '/activate/:activation_code' => 'users#activate', :as =>:activate
match '/email_activate/:primary_activiation_code' => 'groups#invite_members', :as =>:email_activate
match '/group_details/id' => 'groups#invite_members', :as =>:group_details
match '/activate/:activation_code' => 'users#activate', :as =>:activate
match '/email_activate/:primary_activiation_code' => 'paid_users#email_activate', :as =>:email_activate
match '/group_details/id' => 'csr#group_details', :as =>:group_details
match '/admin' => 'admin_sessions#new', :as =>:login
match '/logout' => 'admin_sessions#destroy', :as =>:logout
match '/user_logout' => 'sessions#destroy', :as =>:user_logout
match '/forgot_password' => 'admins#forgot_password', :as =>:forgot_password
match '/reset_password/:id' => 'admins#reset_password', :as =>:reset_password
match '/user_forgot_password' => 'users#forgot_password', :as =>:user_forgot_password
match '/user_reset_password/:id' => 'users#reset_password', :as =>:user_reset_password
match '/close_code/:id' => 'users#close_code', :as =>:close_code
match '/user_close_account_reason/:id' => 'users#close_account_reason'
match  '/paid_users/change_email'=>'paid_users#change_email'


#billing_history_admin_billing_informations_path
#view_log_group_admin_billing_informations_path

# map.user_close_account_reason '/user_close_account_reason/:id', :controller => 'users', :action => 'close_account_reason'
match '/close_account' => 'users#close_account', :as =>:close_account
match '/change_password/:id' => 'admins#change_password', :as =>:change_password
match '/billing_history'=>'admin/billing_informations#billing_history',:as=>:billing_history_admin_billing_informations
match '/view_log_group'=>'admin/billing_informations#view_log_group',:as=>:view_log_group_admin_billing_informations

match '/construction' => 'sessions#construction', :as =>:construction
match '/invite/:invitation_code' => 'users#invite', :as =>:invite
match 'invite_leader/:invitation_code' => 'users#invite_leader', :as =>:invite_leader
match '/signup' => 'users#new', :as =>:user_signup
match '/signup2' => 'users#signup', :as =>:user_signup2
match '/signup2/edit' => 'users#edit_profile', :as =>:users_edit
match '/check_users_account' => 'users#check_users_account', :as =>:check_users_account
match '/create' => 'users#create', :as =>:user_signup2
match '/dashboard' => 'users#dashboard', :as =>:dashboard
match '/rpx_signup' => 'users#signup3', :as =>:rpx_signup
match '/rpx_user_create' => 'users#rpx_create', :as =>:rpx_users_create
match '/manager_dashboard' => 'admins#new', :as =>:manager_dashboard
match '/csr_dashboard' => 'admins#csr_dashboard', :as =>:csr_dashboard
match '/csr_list' => 'csrs#list', :as =>:csr_list
match '/csr_new' => 'csrs#new', :as =>:csr_new
match '/csr_create' => 'csrs#create', :as =>:csr_create
match '/pricing_edit' => 'pricing_controls#edit', :as =>:pricing_edit
match '/new_objectives/:id' => 'groups#new_objectives', :as =>:new_objectives ,:via=>:get
#match '/paid_users/change_email?'=>'paid_users#change_email'
#No route matches {:action=>"pay_bill", :plan=>"2", :coupon_code=>"123", :controller=>"paid_user"
#paid_users/pay_bill?coupon_code=123&plan=2
#match '/paid_users/pay_bill/:plan/:coupon_code'=>'paid_users#pay_bill',:as=>:paid_users_pay_bill
  resources :csrs do
  collection do
	  get :activity_log
	  get :view_log_group
	    end
    end
    
    # map.email_activate '/email_activate/:primary_activiation_code',:controller =>'paid_users',:action =>'email_activate'
    
#      map.resource :paid_users,:collection=>{:change_email=>:get,:select_plan=>:get, :update_creditcard=>:get,:billing_history=>:get},:member=>{:create_pay_bill=>:post}
#map.resource :paid_users,:collection=>{:change_email=>:get,:select_plan=>:get, :update_creditcard=>:get,:billing_history=>:get},:member=>{:create_pay_bill=>:post}
resources :paid_users do
    collection do
	  get :change_email
	  get :select_plan
	  get :update_creditcard
	  get :billing_history
	  
   end
   member do
	   		post :pay_bill
			
		end
	end
#get 'paid_users/pay_bill'
#post  'paid_users/pay_bill' =>  'paid_users#pay_bill'
	#match 'paid_users/pay_bill' =>'paid_users#pay_bill',:as=>:add_plan, :via=>:post
			#match 'paid_users/pay_bill/:coupon_code/:plan' =>'paid_users#pay_bill',:as=>:add_plan, :via=>:get

resources :group_activities do
  collection do
	  get :attachment_file
	   end
   member do
	   		post:post_comment
			 get :status_comment
	  end
    end
  resources :group_infos do
    collection do
	  get :objectives
	 get :objective_cancel
   end
   member do
	   		post:invite_contact
			 get :group_info
			 get :suspend_group
			 get :edit_group
			 put :update_group
			 put :disable_member
	 put :delete_member
	  get :display_member
	   get :add_group_owner
	   get :display_contacts
		post:invite
		post:send_invitation
		post:invite_members
		post:final_contacts
		post:disable_member
		   get :edit_objective_owners
		   		   put :update_objective_owners
			post:activate_member
  end
  end
 resources :messages do
  collection do
	  get :save_file
	 get :trash
	 get :undelete
	 get :message_thread
	 get :footer
	 get :more_groups
	  get :inbox_footer
	 get :draft_footer
	 get :sent_footer
	  get :delete_all_trash
	 get :update_inbox
   end
   member do
	   		post:post_in_message_thread
			 get :find_group_members
			 get :reply_message
			 put :conclude_thread
			post:post_reply
  end
   end
   resources :access_codes do
  collection do
	  get :generate_code
		    end
   end 
   match '/inbox' => 'messages#inbox', :as =>:inbox
match '/sentitems' => 'messages#sentitems', :as =>:inbox
match '/drafts' => 'messages#drafts', :as =>:inbox
   match '/support' => 'staticpages#support', :as =>:support
match '/privacy' => 'staticpages#privacy', :as =>:privacy
     match '/features' => 'staticpages#features', :as =>:features
match '/about_us' => 'staticpages#about_us', :as =>:about_us
   match '/terms_cond' => 'staticpages#terms_cond', :as =>:terms_cond
 #~ namespace :admin do
	 #~ resource :groups
	#~ resource :billing_informations
	#~ resource :billing_informations do
			#~ get :billing_history, :on => :collection
		#~ get :view_log_group, :on => :collection
				#~ get :back_link, :on => :collection
			#~ end
		#~ end	
	
match '/getstart' => 'fbhome#getstart', :as =>:getstart
match '/get_session' => 'fbhome#get_session', :as =>:get_session
     match '/test_session' => 'fbhome#create_test_session', :as =>:create_test_session
match '/post_message' => 'fbhome#post_message', :as =>:post_message
   match '/wrong_message' => 'messages#wrong_message', :as =>:wrong_message

match ':controller/:action/:id' 
match ':controller/:action/:id.:format'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  
# match ' :action=>"pay_bill", :plan=>"2", :coupon_code=>"123", :controller=>"paid_users"
end
