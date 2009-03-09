# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include CredentialStore
  require 'net/ldap'
  require 'aes_crypt'
  
  helper :all # include all helpers, all the time
  before_filter :authenticate
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => '052cb93edcaaa126e814e2908a5faaed'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  # Configuration variables for authentication
  TREEBASE = 'DC=PEROOT,DC=COM'
  DOMAIN = "PEROOT\\"
  LDAP_SERVER = 'ussatx-ad-001.peroot.com'
  LDAP_SERVER_PORT = 389
  
  def searchForComputersByKeyword ( searchString )
    servers = contentServerList
    computerList = Array.new
    wordarray = searchString.split(/ /)
    servers.each do |server|
      wordarray.each {|word|
        computerHash = Hash.new
        computerList = computerList + server.findComputersByUser(searchString)
        computerList = computerList + server.findComputersByName(searchString)
        computerList = computerList + server.findComputersByID(searchString)
        
        computerList.each{ |computer|
          if(computerHash[computer.remote_id])
            computerHash[computer.remote_id] = computerHash[computer.remote_id] + 1
          else 
            computerHash[computer.remote_id] = 1
          end
        }
        computerList = computerHash.sort do |a,b|
          a[1] <=> b[1]
        end
        computerList.each do |computerResult|
          computerResult[0] = SmsComputer.findOrCreate(computerResult[0], server)
        end
      }
    end
    return computerList
  end
  def searchForPackagesByKeyword ( searchString )
    servers = contentServerList
    packagesList = Array.new
    wordarray = searchString.split(/ /)
    servers.each do |server|
      packagesHash = Hash.new
      wordarray.each {|word|
        packagesList = packagesList + server.findPackagesByManufacturer(word)
        packagesList = packagesList + server.findPackagesByName(word)
        packagesList = packagesList + server.findPackagesByVersion(word)
        packagesList.each{ |package|
          if(packagesHash[package.remote_id])
            packagesHash[package.remote_id] = packagesHash[package.remote_id] + 1
          else 
            packagesHash[package.remote_id] = 1
          end
        }
        packagesList = Array.new()
      }
      packagesList = packagesHash.sort do |a,b|
        a[1] <=> b[1]
      end
      packagesList.each do |packageResult|
        packageResult[0] = SmsPackage.findOrCreate(packageResult[0], server)
      end
    end
    return packagesList
  end
  def searchForComputerGroupsByKeyword ( searchString )
    servers = contentServerList
    resultList = Array.new()
    wordarray = searchString.split(/ /)
    servers.each do |server|
      computerGroupList = Array.new
      computerGroupHash = Hash.new
      wordarray.each {|word|
        computerGroupList = computerGroupList + server.findComputerGroupsByName(word)
      
        computerGroupList.each{ |computerGroup|
          if(computerGroupHash[computerGroup.remote_id])
            computerGroupHash[computerGroup.remote_id] = computerGroupHash[computerGroup.remote_id] + 1
          else 
            computerGroupHash[computerGroup.remote_id] = 1
          end
        }
      }
      computerGroupList = computerGroupHash.sort do |a,b|
        a[1] <=> b[1]
      end
      computerGroupList.each do |computerGroupResult|
        computerGroupResult[0] = SmsComputerGroup.findOrCreate(computerGroupResult[0], server)
      end
      resultList = resultList + computerGroupList
    end
    resultList = resultList.sort do |a, b|
      a[1] <=> b[1]
    end
    return resultList
  end
  def contentServerList
    serverRecords = ContentServer.find(:all)
    serverObjects = Array.new()
    serverRecords.each do |serverRecord|
      serverObjects << serverRecord.contentServerObject
    end
    return serverObjects
  end

  protected
  
  def authenticate
    puts "Starting Authentication"
    authenticate_or_request_with_http_basic do |username, password|
      ldap_con = initialize_ldap_con(DOMAIN + username,password)
      treebase = TREEBASE 
      user_filter = Net::LDAP::Filter.eq( 'sAMAccountName', username )
      op_filter = Net::LDAP::Filter.eq( 'objectClass', 'organizationalPerson' ) 
      dn = String.new
      ldap_con.search( :base => treebase, :filter => op_filter & user_filter, :attributes=> 'dn') do |entry|
        dn = entry.dn
      end
      puts "Finished Searching"
      login_succeeded = false
      unless dn.empty?
        puts "Dn : " + dn.to_s
        ldap_con = initialize_ldap_con(dn,password)
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
    Net::LDAP.new( {  :host => LDAP_SERVER, 
                      :port => LDAP_SERVER_PORT, 
                      :auth => {  :method   => :simple, 
                                  :username => user_name, 
                                  :password => password }}) 
  end

end
