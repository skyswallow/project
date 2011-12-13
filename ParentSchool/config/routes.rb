ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
  
  map.namespace :admin do |admin|
    admin.resources :news_lines, :collection => {:picture =>:get, :upload => :post, :checkimg => :post, 
      :check => :post, :checksub => :get},
      :member => {:release => :get, :recommend => :get, :cancle_recommend => :get}
    admin.resources :change_partials, :collection => {:index_preview => :get, :parent => :get, :exam => :get, :class => :get, :book => :get,:blog => :get, :school => :get}
    admin.resources :resources

    admin.resources :page_records, :collection =>{:to_excel => :get,:to_excel_high => :get,:to_excel_history=> :get, :high_search => :get, :page_history => :get}
    admin.resources :action_records, :collection =>{:search_school_name => :get,:search_class_name => :get,:search_message_type => :get ,:to_excel => :get }
    admin.resources :time_statistics
    admin.resources :incoming_pages
    admin.resources :user_records
    admin.resources :contributions, :member =>{:download => :get, :set_undo => :get, :set_do => :get}
    admin.resources :notices, :collection => {:preview =>:get}
    admin.resources :lectures
    admin.resources :activities, :collection => {:preview => :get}
    admin.resources :activity_users
    admin.resources :menus, :collection => {:topics => :get, :topic_comments => :get, :albums => :get, :pictures => :get, :group_resources => :get, :class_log_comments => :get, :class_resources => :get, :groups_resources => :get,
      :entry_applications => :get, :entries => :get, :class_roles => :get, :teacher_login_reports => :get, :parent_login_reports => :get, :groups => :get, :groups_deleted => :get, :group_topics => :get, :group_pictures => :get,
      :notice_reports => :get, :net_class_reports => :get, :class_tree_reports => :get, :teacher_login_lists => :get, :parent_login_lists => :get, :super_login => :get, :group_topic_comments => :get, :group_albums => :get,
      :notice_lists => :get, :net_class_lists => :get, :class_tree_lists => :get, :reps => :get, :book_reviews => :get, :books => :get, :entry_comments => :get, :help_comments => :get, :pic_comments => :get, :message => :get, :passwords => :get,
      :message_reports => :get
    }
    admin.resources :book_activities, :collection => {:lottery => :post}
  end
  map.namespace :manage do |manage|
    manage.resources :news, :collection => {:preview => :get, :search => :get}
  end
  map.resources :schools,:collection=>{:check_region => :get}
  map.resources :home, :collection => {:get_proof_code => :get, :logout => :get}
  map.resources :notices
  map.resources :welcome
  map.resources :examination
  map.resources :activities
  map.resources :driftages, :collection => {:add_apply => :get, :topics => :get, :add_topic => :get}
  map.resources :news_lines, :collection => {:news => :get, :parent_class => :get, :book => :get},
    :member => {:sub_parent_class => :get, :sub_news => :get, :month_news => :get}
  map.resources :resources, :collection => {:types => :get, :search => :get}, :member => {:download => :get}
  map.resources :blogs
  map.resources :net_classes
  map.resources :foots, :collection => {:about_school => :get, :declare => :get}
  map.resources :areas, :collection => {:result => :get}
  map.resources :lectures, :collection => {:get_proof_code => :get}
  map.resources :book_activities, :collection => {:apply => :post, :introduction => :get,
    :award_list => :get, :report => :get, :article => :get, :survey => :get, :lottery => :get,
    :change_status => :get, :do_lottery => :post, :get_user_status => :get, :award_search => :post, :download => :get
  }
  map.resources :book_exchanges, :collection => {:search_user_name => :post, 
    :select_book => :get, :alert_div => :get, :jiaohuan => :post,
    :get_user_status => :get, :zengyu => :post,:current_book => :get}
  map.resources :book_plans, :collection => {:apply => :post, :introduction => :get,
    :award_list => :get, :report => :get, :download => :get, :article => :get}
  map.resources :book_tests, :collection => {:apply => :post, :introduction => :get,
    :award_list => :get, :report => :get, :article => :get}
  map.resources :driftages, :collection => {:login => :post, :forget => :get, :send_pass_back => :get, :book_list => :get,
    :book_detail => :get}  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end