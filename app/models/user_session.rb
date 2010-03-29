class UserSession < Authlogic::Session::Base
  logout_on_timeout=true
  logged_in_timeout=10.minutes
end