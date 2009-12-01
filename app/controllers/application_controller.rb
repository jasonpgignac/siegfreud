# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include CredentialStore
  require 'net/ldap'
  require 'aes_crypt'
  require 'csv'
  
  helper :all # include all helpers, all the time
  # before_filter :authenticate
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => '052cb93edcaaa126e814e2908a5faaed'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  helper_method :current_user
  
  # Configuration variables for authentication
  TREEBASE = 'DC=PEROOT,DC=COM'
  DOMAIN = "PEROOT\\"
  LDAP_SERVER = 'ussatx-ad-001.peroot.com'
  LDAP_SERVER_PORT = 389
  
  protected
  
  def authenticate
    puts "Starting Authentication"
    authenticate_or_request_with_http_basic do |username, password|
      ldap_con = Net::LDAP.new( { :host => "ussatx-ad-001.peroot.com", :port => 389, :auth => {:method => :simple, :username => "peroot\\ugignja", :password => "Car0lineBlack" }}) 
      
      treebase = TREEBASE 
      user_filter = Net::LDAP::Filter.eq( 'sAMAccountName', username )
      op_filter = Net::LDAP::Filter.eq( 'objectClass', 'organizationalPerson' ) 
      dn = String.new
      puts treebase + " " + user_filter.to_s
      ldap_con.search( :base => treebase, :filter => user_filter, :attributes=> 'dn') do |entry|
        dn = entry.dn
      end
      puts "Finished Searching"
      login_succeeded = false
      unless dn.empty?
        puts "Dn : " + dn.to_s
        ldap_con = Net::LDAP.new( { :host => "ussatx-ad-001.peroot.com", :port => 389, :auth => {:method => :simple, :username => "peroot\\ugignja", :password => "Car0lineBlack" }})
        if ldap_con.bind
          login_succeeded = true
          unless (self.cs_credentials(:default) == {:username => (DOMAIN + username), :password => password})
            puts "OK, so we need to reset the session"
            self.cs_reset 
            self.cs_set_credentials(:default, (DOMAIN + username), password)
          end
          ContentServer.content_store = self.cs
          puts "Content store : " + self.cs.to_s
        else
          puts "Bind failed!"
          login_succeeded = false
        end
      end
      puts login_succeeded.to_s
      login_succeeded
    end
  end
  def initialize_ldap_con(user_name, password)
    return Net::LDAP.new( { :host => "ussatx-ad-001.peroot.com", :port => 389, :auth => {:method => :simple, :username => "peroot\\ugignja", :password => "Car0lineBlack" }}) 
  end
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
