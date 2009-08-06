class Package < ActiveRecord::Base
    has_many :licenses
    has_many :bundle_members
    has_many :computers, :through => :licenses
    
    define_index do
      indexes manufacturer
      indexes :name
      indexes version
    end
    
    def assigned_licenses
      self.licenses.delete_if do |license| license.open? end
    end
    def short_name
      self.manufacturer.to_s + " " + self.name.to_s + " " + self.version.to_s
    end
    def get_open_license(division)
      lic = License.find_by_package_id(self.id, :conditions => {:computer_id => nil, :division => division.to_s})
      raise(RuntimeError,"No Licenses Available",caller) if lic.nil?
      lic
    end
    def add_license_to_computer(comp)
      comp.add_package(self)
    end
end
