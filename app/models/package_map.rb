class PackageMap < ActiveRecord::Base
  belongs_to :package
  belongs_to :server
  
  validates_presence_of :remote_package_id, :server, :package
end
