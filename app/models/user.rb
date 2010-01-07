class User < ActiveRecord::Base
  acts_as_authentic
  def role_symbols
    roles = Array.new
    roles << :admin if admin
    roles << :technician if technician
    roles << :reporter if reporter
    return roles
  end
end
