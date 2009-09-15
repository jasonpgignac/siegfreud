class Package < ActiveRecord::Base
    has_many :licenses
    has_many :bundle_members
    has_many :computers, :through => :licenses
    has_many :package_maps
    
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
      self.licenses.delete_if do |license| license.open? end
    end
    def short_name
      self.manufacturer.to_s + " " + self.name.to_s + " " + self.version.to_s
    end
    def get_open_license(division)
      lic = License.find_by_package_id(self.id, :conditions => {:computer_id => nil, :division_id => division.id})
      raise(RuntimeError,"No Licenses Available",caller) if lic.nil?
      lic
    end
    def add_license_to_computer(comp)
      comp.add_package(self)
    end
end
