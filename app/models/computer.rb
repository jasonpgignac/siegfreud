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
  
  validates_presence_of :division, :serial_number, :model, :po_number
  validate :must_have_proper_stage_data
  validates_uniqueness_of :serial_number
  define_index do
    indexes :name
    indexes serial_number
    indexes owner
    indexes po_number
    indexes model
    set_property :delta => true
  end
  
  def available_stages
    stage.available_stages + stage
  end
  def to_param
    serial_number
  end
  # Virtual Attributes
  def servers
    server_domains.collect do |sd|
      sd.server
    end
  end
  def available_stages
    stage.available_stages
  end
  def short_name
    if (self.stage == "active")
      self.name + ":(" + self.owner + ")"
    else
      self.model + ":(" + self.serial_number + ")"
    end
  end
  def current_location
    self.stage.name + ": " + (self.owner.nil? ? self.location.to_s : self.owner.to_s)
  end

  # Inventory Creation Functions
  def self.create_with_po(po, params)
    computer = Computer.new
    computer.last_stage_change = Date.today;
    computer.po_number = po.po_number
    computer.division_id = po.division_id
    computer.stage = "Storage"
    computer.update_attributes(params)
    computer.save
    
    Action.create_with_inventory_objects( "Create Record", 
                                          "PO\# #{computer.po_number}\n" +
                                          "Division #{computer.division_id}\n" +
                                          params.to_s, 
                                          [ computer ])
    return computer
  end
  def edit_with_params(params)
    self.update_attributes(params)
    self.save
    
    Action.create_with_inventory_objects( "Edit Record", 
                                          params.to_s, 
                                          [self])
    return self
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
  def change_stage(new_stage, attributes = nil)
    attributes = Hash.new if attributes.nil?
    puts "Changing from #{self.stage} to #{new_stage}"
    case [self.stage, new_stage]
    when  ["Storage", "Rollout"],
          ["Active", "Repair"],
          ["Storage", "Active"],
	  ["Rollout", "Active"]
      test_deployment_data(attributes)
    when  ["Rollout", "Storage"],
          ["Rollout", "Disposal"],
          ["Active", "Storage"],
          ["Active", "Disposal"],
          ["Repair", "Storage"],
          ["Retrieval", "Storage"],
          ["Retrieval", "Disposal"],
          ["Active", "Retrieval"],
          ["Rollout", "Retrieval"],
          ["Disposal", "Storage"],
	  ["Storage", "Disposal"]
      test_location_data(attributes)
    when  ["Storage", "Retrieval"],
          ["Active", "Rollout"],
          ["Retrieval", "Rollout"],
          ["Retrieval", "Active"],
          ["Disposal", "Rollout"],
          ["Disposal", "Active"],
          ["Disposal", "Retrieval"]
      illegal_transition_error
    else
      illegal_transition_error
    end
    case [self.stage, new_stage]
    when  ["Rollout", "Storage"],
          ["Rollout", "Disposal"],
          ["Active", "Storage"],
          ["Active", "Disposal"],
          ["Repair", "Storage"],
          ["Retrieval", "Storage"],
          ["Retrieval", "Disposal"]
      clear_deployment_data
      clear_licensing_and_peripherals
    end
    old_stage = self.stage;
    self.stage = new_stage;
    self.last_stage_change = Date.today;
    self.save
    Action.create_with_inventory_objects("Stage Change", "Changed from #{old_stage} to #{new_stage}", [ self ])
  end
  def test_deployment_data(attributes)
    unless (attributes.key?(:owner) and attributes.key?(:system_role) and attributes.key?(:name) and attributes.key?(:domain))
      raise(RuntimeError,"TransitionRequiresDeploymentData",caller)
    end
    self.owner = attributes[:owner]
    self.system_role = attributes[:system_role]
    self.name = attributes[:name]
    self.domain = attributes[:domain]
  end 
  def test_location_data(attributes)
    puts "TEST: Testing Location Data"
    unless(attributes.has_key?(:location))
      raise(RuntimeError,"TransitionRequiresLocationData",caller)
    end
    self.location = attributes[:location]
  end
  def illegal_transition_error
    raise(RuntimeError,"TransitionIsIllegal",caller)
  end
  def clear_deployment_data
    self.owner = self.system_role = self.name = self.domain = nil
  end
  def clear_licensing_and_peripherals
    self.licenses.each do |lic|
      remove_license(lic)
    end
    self.peripherals.each do |periph|
      remove_peripheral(periph)
    end
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
  # Validation Routines
  def must_have_proper_stage_data
    if(stage.nil?)
      errors.add_to_base("Stage is not defined")
    else
      must_have_proper_location_data
      must_have_proper_deployment_data
    end
  end
  def must_have_proper_location_data
    if(stage.has_location)
      errors.add_to_base("This stage requires the location field to be defined") if (location.nil? || location.empty?)
    end
  end
  def must_have_proper_deployment_data
    if(stage.has_deployment)
      invalid_deployment_fields = owner.nil? || owner.empty? || system_role.nil? || system_role.empty? || name.nil? || name.empty?
      invalid_domain = domain.nil? || !(domain.valid?) 
      errors.add_to_base("This stage requires the owner, domain, system role and name to be defined") if (invalid_deployment_fields || invalid_domain)
    end
  end
  
  # Other
  def to_json
    
  end
end
