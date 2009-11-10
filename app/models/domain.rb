class Domain < ActiveRecord::Base
  has_many :server_domains
  has_many :computers
end
