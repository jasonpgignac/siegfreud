class ActionInventoryObject < ActiveRecord::Base
  belongs_to :inventory_object, :polymorphic => true
  belongs_to :action
end
