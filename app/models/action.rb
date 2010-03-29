class Action < ActiveRecord::Base
  has_many :action_inventory_objects
  has_many :inventory_objects, :through => :action_inventory_objects
  
  def self.create_with_inventory_objects(title, comment, inventory_objects, user=nil)
    new_action = Action.new()
    new_action.title = title
    new_action.description = comment
    new_action.user = user
    new_action.save
    inventory_objects.each do |obj|
      aio = ActionInventoryObject.new
      aio.action = new_action
      aio.inventory_object = obj
      aio.save
    end
    new_action.save
    return new_action
  end
end
