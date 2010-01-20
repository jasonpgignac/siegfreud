class SiteMap < ActiveRecord::Base
  belongs_to :site
  belongs_to :server
  
  validates_presence_of :site, :server, :remote_site_id
end
