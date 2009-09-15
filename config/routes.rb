ActionController::Routing::Routes.draw do |map|
  map.connect 'divisions/:division_id/computers.:format',
	:controller => "computers",
	:action => "index"
  map.resources :divisions

  map.resources :packages do |r|
    r.resources :maps, :controller => :package_maps
  end
  map.resources :licenses, :has_many => :actions
  map.resources :peripherals, :has_many => :actions
  map.resources :computers, :has_many => :actions
  map.resources :purchase_orders
  
  map.connect ':controller/:action/:id', :controller => 'main'
  map.connect ':controller/:action/:id.:format'
  
end
