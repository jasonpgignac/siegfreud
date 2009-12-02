authorization do
  role :admin do
    has_permission_on [:computers], :to => [:index, :show, :new, :create, :edit, :update]
  end
  
  role :guest do
    has_permission_on [:user_sessions], :to => [:new]
  end
end