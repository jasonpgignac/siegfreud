ActionController::Routing::Routes.draw do |map|
  map.resources :peripherals

  map.resources :user_sessions
  map.resources :users
  map.resources :domains
  map.resources :servers
  map.connect 'divisions/:division_id/computers.:format',
	:controller => "computers",
	:action => "index"
  map.resources :divisions
  map.resources :packages do |r|
    r.resources :maps, :controller => :package_maps
    r.resources :licenses
  end
  map.resources :licenses, :has_many => :actions
  map.resources :peripherals, :has_many => :actions, :only => [:index, :show]
  map.resources :computers do |r| 
    r.resources :actions, :only => [:index, :show]
    r.resources :licenses
    r.resources :peripherals, :only => [:index, :show], :member => { :add => :put }
  end
  map.resources :purchase_orders
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.root :controller => "main", :action => "index"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
