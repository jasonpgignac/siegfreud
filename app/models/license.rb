class License < ActiveRecord::Base
  belongs_to :package
  belongs_to :computer
  has_many :action_inventory_objects, :as => :inventory_object
  has_many :actions, :through => :action_inventory_objects
  
  # Inventory Creation Functions
  def self.create_with_po(po, params)
    license = License.new
    license.po_number = po.po_number
    license.division = po.division
    license.update_attributes(params)
    license.save
    
    Action.create_with_inventory_objects( "Create Record", 
                                          "PO\# #{license.po_number}\n" +
                                          "Division #{license.division}\n" +
                                          params.to_s, 
                                          [ license ])
    return license
  end
  
  def open?
    self.computer_id.nil?
  end
  def assigned?
    !(self.open?)
  end
  def short_name
    package.short_name
  end  
  def current_location
    unless self.computer_id.nil?
      computer.short_name + ": " + (computer.owner.nil? ? computer.location : computer.owner)
    else
      "Unassigned"
    end
  end
  
  
  def remove_from_computer
    self.computer.remove_license(self)
  end
end
