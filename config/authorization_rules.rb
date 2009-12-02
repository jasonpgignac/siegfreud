authorization do
  role :admin do
    includes :user
    has_permission_on [:users], :to => [:index, :new, :create, :edit, :update]
  end
  role :inventory_specialist do
    includes :user
    has_permission_on [:computers], :to => [:index, :show, :new, :create, :edit, :update]
  end
  role :technician do
    includes :user
    has_permission_on [:computers], :to => [:index, :show, :new, :create, :edit, :update]
  end
  role :reporter do
    includes :user
    has_permission_on [:computers], :to => [:index, :show]
  end
  role :user do
    has_permission_on [:users], :to => [:edit, :update] do
      if_attribute :id => is {user.id}
    end
    has_permission_on [:user_sessions], :to => [:destroy]
  end
  
  role :guest do
    has_permission_on [:user_sessions], :to => [:new, :create]
    has_permission_on [:users], :to => [:new, :create]
  end
end
