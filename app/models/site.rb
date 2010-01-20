class Site < ActiveRecord::Base
  has_many :site_maps
  has_many :servers, :through => :site_maps
  validates_presence_of :name
  
  def services_of_type(service_type)
    self.servers.delete_if {|s| !(s.contains_service_of_type?(service_type)) }.collect {|s| s.service_of_type(service_type)}
  end
  def service_of_type_and_name(species, name)
    svcs = services_of_type(species)
    svcs.delete_if { |s| s.name != name }
    raise(RuntimeError, "No Matching service for ['#{species}', '#{name}'] for the site '#{name}'") if svcs.empty?
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
