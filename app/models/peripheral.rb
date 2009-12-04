class Peripheral < ActiveRecord::Base
  belongs_to :computer
  belongs_to :division
  belongs_to :stage
  has_many :available_stages, :through => :stage
  has_many :action_inventory_objects, :as => :inventory_object
  has_many :actions, :through => :action_inventory_objects
  
  validates_presence_of :po_number, :serial_number, :division, :model
  validates_uniqueness_of :serial_number
  validates_presence_of :location, :if => Proc.new{ |p| p.stage && p.stage.has_location && !(p.computer)}
  validates_presence_of :owner, :description, :if => Proc.new { |p| p.stage && p.stage.has_deployment && !(p.computer)}
  validates_presence_of :stage, :unless => Proc.new { |p| p.computer }
  define_index do
    indexes serial_number
    indexes model
    set_property :delta => true
  end
  
  # Inventory Creation Functions
  def available_stages
    self.stage.available_stages.to_a.unshift(self.stage)
  end
  def valid_change?(new_stage)
    self.stage && self.stage.valid_change?(new_stage)
  end
  
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
