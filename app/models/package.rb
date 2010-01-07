class Package < ActiveRecord::Base
    has_many :licenses
    has_many :bundle_members
    has_many :computers, :through => :licenses
    has_many :package_maps
    
    validates_presence_of :manufacturer, :name, :version
    
    define_index do
      indexes manufacturer
      indexes :name
      indexes version
    end
    
    def to_json(options=nil)
      @package_hash = Hash.new
      @package_hash[:id] = self.id
      @package_hash[:manufacturer] = self.manufacturer
      @package_hash[:name] = self.name
      @package_hash[:version] = self.version
      @package_hash[:description] = nil
      @package_hash[:freshness_date] = DateTime.now
      @package_hash.to_json
    end
    def assigned_licenses
      self.licenses.find(:all, :conditions => "computer_id IS NOT NULL AND computer_id IS NOT ''")
    end
    def short_name
      self.manufacturer.to_s + " " + self.name.to_s + " " + self.version.to_s
    end
    def get_open_license(division = nil)
      if division
        lic = self.licenses.find(:first, :conditions => {:computer_id => nil, :division_id => division.id})
      else
        lic = self.licenses.find(:first, :conditions => {:computer_id => nil})
      end
      return lic if lic
      raise ActiveRecord::RecordNotFound
    end
    def add_license_to_computer(comp)
      comp.add_package(self)
    end
    
    def servers
      package_maps.collect { |pm| pm.server }
    end
    def services_of_type(service_type)
      self.servers.delete_if {|s| !(s.contains_service_of_type?(service_type)) }.collect {|s| s.service_of_type(service_type)}
    end
    def service_of_type_and_name(species, name)
      svcs = services_of_type(species)
      svcs.delete_if { |s| s.name != name }
      raise(RuntimeError, "No Matching service for ['#{species}', '#{name}'] for the package '#{short_name}'") if svcs.empty?
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
