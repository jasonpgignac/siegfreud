class Server < ActiveRecord::Base
  has_many :server_domains
  has_many :site_maps
  has_many :package_maps
  has_many :domains, :through => :server_domains
  
  validates_presence_of :name, :species, :address
  validates_uniqueness_of :name
  def species_description
    @sd ||= YAML.load_file("#{RAILS_ROOT}/config/mashups/server_types/#{species}.yml")
  end
  def services
    return @services if @services
    
    @services = Hash.new
    species_description[:services].each do |srv_desc|
      services[srv_desc[:platform]] ||= Hash.new
      if srv_desc[:variables]
        @services[srv_desc[:platform]][srv_desc[:type]] = eval("ValhallaMashup::" + srv_desc[:type] + "Service").new(address, srv_desc[:variables])
      else
        @services[srv_desc[:platform]][srv_desc[:type]] = eval("ValhallaMashup::" + srv_desc[:type] + "Service").new(address)
      end
      @services[srv_desc[:platform]][srv_desc[:type]].name = name
    end
    return @services
  end
  def contains_service_of_type?(service_type, platform= nil)
    if platform
      return false if services[platform].nil?
      return false if services[platform][service_type].nil?
    else
      service_list = services.collect{|k,v| v[service_type]}.compact
      return false if service_list.size == 0
    end 
    return true
  end
  def service_of_type(service_type, platform=nil)
    raise(RuntimeError, "Server does not have a service to match [#{service_type}, #{platform}]") unless contains_service_of_type?(service_type, platform)
    platform ? services[platform][service_type] : services.collect{|k,v| v[service_type]}.compact[0]
  end
end
