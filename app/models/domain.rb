class Domain < ActiveRecord::Base
  has_many :server_domains
  has_many :computers
  
  def bare_name
    name =~ /(([A-Z]|[a-z])*)\./
    return $1
  end
end
