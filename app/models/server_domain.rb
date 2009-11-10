class ServerDomain < ActiveRecord::Base
  belongs_to :server
  belongs_to :domain
end
