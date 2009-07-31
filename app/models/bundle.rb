class Bundle < ActiveRecord::Base
  has_many :bundle_members
  has_many :packages, :through => :bundle_members
  
  define_index do
    indexes :name
    indexes description
  end
  
  def get_open_licenses(division)
    lics = Array.new
    packages.each do |pkg|
      lic = pkg.get_open_license(division)
      lics << lic
    end
    lics
  end
  
  def short_name
    self.name
  end
end
