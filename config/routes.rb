ActionController::Routing::Routes.draw do |map|
  map.resources :packages
  map.resources :licenses, :has_many => :actions
  map.resources :peripherals, :has_many => :actions
  map.resources :computers, :has_many => :actions
  map.resources :purchase_orders
  
  map.connect ':controller/:action/:id', :controller => 'main'
  map.connect ':controller/:action/:id.:format'
  
end
