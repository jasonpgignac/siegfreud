class Server < ActiveRecord::Base
  has_many :server_domains
  has_many :domains, :through => :server_domains
end
