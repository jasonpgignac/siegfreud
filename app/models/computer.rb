class Computer < ActiveRecord::Base
  has_many :licenses
  has_many :peripherals
  has_many :packages, :through => :licenses
  
  define_index do
    indexes :name
    indexes serial_number
    indexes mac_address
    indexes owner
    indexes po_number
    indexes model
    set_property :delta => true
  end
  
  def short_name
    if (self.stage == "active")
      self.name + ":(" + self.owner + ")"
    else
      self.model + ":(" + self.serial_number + ")"
    end
  end
  
  def clear_deployment_data
    self.owner = nil
    self.name = nil
    self.domain = nil
    self.system_role = nil
    self.save
    self.peripherals.each do |periph|
      periph.computer_id = nil
      periph.save
    end
    self.licenses.each do |lic|
      lic.computer_id = nil
      lic.save
    end
  end
end
