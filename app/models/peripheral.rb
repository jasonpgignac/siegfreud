class Peripheral < ActiveRecord::Base
  belongs_to :computer
  belongs_to :division
  has_many :action_inventory_objects, :as => :inventory_object
  has_many :actions, :through => :action_inventory_objects
  
  define_index do
    indexes serial_number
    indexes model
    set_property :delta => true
  end
  
  # Inventory Creation Functions
  def self.create_with_po(po, params)
    periph = Peripheral.new
    periph.po_number = po.po_number
    periph.division_id = po.division_id
    periph.update_attributes(params)
    periph.save
    
    Action.create_with_inventory_objects( "Create Record", 
                                          "PO\# #{periph.po_number}\n" +
                                          "Division #{periph.division.display_name}\n" +
                                          params.to_s, 
                                          [ periph ])
    return periph
  end
  def edit_with_params(params)
    self.update_attributes(params)
    self.save
    
    Action.create_with_inventory_objects( "Edit Record", 
                                          params.to_s, 
                                          [self])
    return self
  end
  
  def current_location
    unless self.computer_id.nil?
      computer.short_name + ": " + (computer.owner.nil? ? computer.location : computer.owner)
    else
      "Storage"
    end
  end
  def short_name
    self.model + self.serial_number
  end
  
  def remove_from_computer
    self.computer.remove_peripheral(self)
  end
end
