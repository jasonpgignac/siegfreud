# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authenticate
  before_filter { |c| Authorization.current_user = c.current_user }
  
  helper :all # include all helpers, all the time
  protect_from_forgery #:secret => '052cb93edcaaa126e814e2908a5faaed'
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user
  
  # Configuration variables for authentication
  TREEBASE = 'DC=PEROOT,DC=COM'
  DOMAIN = "PEROOT\\"
  LDAP_SERVER = 'ussatx-ad-001.peroot.com'
  LDAP_SERVER_PORT = 389
  def authenticate
    redirect_to login_path unless current_user
  end
  def initialize_ldap_con(user_name, password)
    return Net::LDAP.new( { :host => "ussatx-ad-001.peroot.com", :port => 389, :auth => {:method => :simple, :username => "peroot\\ugignja", :password => "Car0lineBlack" }}) 
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
