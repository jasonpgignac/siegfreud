class Computer < ActiveRecord::Base
  has_many :licenses
  has_many :peripherals
  has_many :packages, :through => :licenses
  has_many :action_inventory_objects, :as => :inventory_object
  has_many :actions, :through => :action_inventory_objects
  belongs_to :domain
  belongs_to :stage
  belongs_to :division
  has_many :server_domains, :through => :domain
  has_many :servers, :through => :server_domains
  has_many :available_stages, :through => :stage
  
  validates_presence_of :division, :serial_number, :model, :po_number, :stage
  validates_uniqueness_of :serial_number
  validates_presence_of :location, :if => Proc.new{ |c| c.stage && c.stage.has_location}
  validates_presence_of :owner, :domain, :system_role, :name, :if => Proc.new { |c| c.stage && c.stage.has_deployment}
  validates_length_of :peripherals, :maximum => 0, :unless => Proc.new { |c| c.stage && c.stage.has_deployment}
  validates_length_of :licenses, :maximum => 0, :unless => Proc.new { |c| c.stage && c.stage.has_deployment}
  
  validate :legal_stage_transition?
  define_index do
    indexes :name
    indexes serial_number
    indexes owner
    indexes po_number
    indexes model
    set_property :delta => true
  end
  
  def available_stages
    self.stage.available_stages.to_a.unshift(self.stage)
  end
  def to_param
    "#{serial_number}"
  end
  
  # Virtual Attributes
  def servers
    server_domains.collect do |sd|
      sd.server
    end
  end
  def short_name
    if (stage && stage.has_deployment)
      self.name + "(#{current_location})"
    else
      "#{model}:#{serial_number}(#{current_location})"
    end
  end
  def current_location
    if self.stage
      self.stage.name + 
        (self.stage.has_location ? ": #{self.location}" : "") +
        (self.stage.has_deployment ? ": #{self.owner}(#{self.system_role})": "")
    else
      return "Undefined Location"
    end
  end

  # Peripheral Assignment Functions
  def add_peripheral(periph)
    # Error Checking
    if(!(periph.computer_id.nil?))
      raise(RuntimeError,"PeripheralAlreadyAssigned",caller)
    elsif(periph.division_id != self.division_d)
      raise(RuntimeError,"PeripheralComputerDivisionMismatch",caller)
    elsif(self.stage == "Storage" || self.stage == "Disposal")
      raise(RuntimeError,"IllegalStageForPeripheralAssignment",caller)
    end
    # Assign Peripheral
    self.peripherals << periph
    Action.create_with_inventory_objects("Add Peripheral to System", "", [ periph, self ])
  end
  def remove_peripheral(periph)
    if periph.computer_id = self.id
      periph.computer_id = nil
      periph.save
      Action.create_with_inventory_objects("Remove Peripheral from System", "", [ periph, self ])
    else
      raise(RuntimeError,"Peripheral_Owner Mismatch",caller)
    end  
  end
  
  # Software Licensing Functions
  def add_bundle(bndl)
    lics = bndl.get_open_licenses(self.division)
    lics.each do |lic|
      self.add_license(lic)
    end
  end
  def add_package(pkg)
    lic = pkg.get_open_license(self.division)
    self.add_license(lic)
  end
  def add_license(lic)
    self.licenses << lic
    self.save
    Action.create_with_inventory_objects("Add License to System", "", [ lic, self ])
  end
  def remove_license(lic)
    if lic.computer_id = self.id
      lic.computer_id = nil
      lic.save
      Action.create_with_inventory_objects("Remove License from System", "", [ lic, self ])
    else
      raise(RuntimeError,"License_Licensee Mismatch",caller)
    end
  end
  
  # Stage Changes
  def valid_change?(new_stage)
    stage.valid_change?(new_stage)
  end
  def legal_stage_transition?
    return true unless stage_id_changed?
    return true unless stage_id_was
    errors.add_to_base("Illegal Stage Transition: #{Stage.find(stage_id_was).name} to #{stage.name}") unless Stage.find(stage_id_was).available_stages.include?(stage)
  end 
  # External Server Data
  def services_of_type(service_type)
    self.servers.delete_if {|s| !(s.contains_service_of_type?(service_type, system_class)) }.collect {|s| s.service_of_type(service_type, system_class)}
  end
  def service_of_type_and_name(species, name)
    svcs = services_of_type(species)
    svcs.delete_if { |s| s.name != name }
    raise(RuntimeError, "No Matching service for ['#{species}', '#{name}'] for the computer '#{short_name}'") if svcs.empty?
    return svcs[0]
  end
  def get_data_set(species, name=nil)
    if name
      return service_of_type_and_name(species, name).info_for(self)
    else
      data = Hash.new()
      services_of_type(species).each do |s|
        data[s.name] = s.info_for(self)
      end
      return data
    end
  end
  
end
