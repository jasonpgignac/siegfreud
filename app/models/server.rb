class Server < ActiveRecord::Base
  has_many :server_domains
  has_many :domains, :through => :server_domains
  
  validates_presence_of :name, :species, :address
  validates_uniqueness_of :name
  def species_description
    @sd ||= YAML.load_file("#{RAILS_ROOT}/config/mashups/server_types/#{species}.yml")
  end
  def services
    species_description["services"]
  end
  def contains_service_of_type?(service_type, platform)
    services.clone.delete_if { |s| !(s['type'] == service_type && s['platform'] == platform) }.size > 0
  end
  def service_of_type(service_type, platform)
    raise(RuntimeError, "Server does not have a service to match [#{service_type}, #{platform}]") unless contains_service_of_type?(service_type, platform)
    svc = eval("ValhallaMashup::" + service_type + "Service").new(address)
    svc.name = name
    svc
  end
end
