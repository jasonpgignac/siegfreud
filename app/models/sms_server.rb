require 'net/https'
require 'uri'
require 'openssl'
require "rexml/document"

class SmsServer 
  include SmsRestCall
  
  attr_accessor :address, :username, :password, :server_id, :server_name

  attr_accessor :smsServer
  USER_ID = 1
  COMPUTER_NAME = 2
  COMPUTER_SERIAL = 3
  COMPUTER_ID = 4
  GROUP_ID = 5
  GROUP_NAME = 6
  PACKAGE_ID = 7
  PACKAGE_MANUFACTURER = 8
  PACKAGE_NAME = 9
  PACKAGE_VERSION = 10
  
  def == (otherSmsServer)
    return (@server_id = otherSmsServer.server_id)
  end
  def server
    return self
  end
  # Computer Group Functions
  def findComputerGroups(query)
    doc = sms_rest_call("findCollection", {"query" => query})
    searchResponse = doc.elements["smsRestSearchResponse"]
    resultsArray = []
    searchResponse.elements.each("collection") do |collection|
      resultsArray << SmsComputerGroup.findOrCreate(collection.get_text.to_s, self)
    end
    resultsArray
  end
  def findComputerGroupsByConditions(conditions)
    query = ""
    conditions.each { |field, value|
      if(field.is_a?(Numeric))          # IF field is numeric, it is using one of the field constants. Translate it to the SMS Equivalent
        case field
          when GROUP_ID
            field = "SMS_Collection.CollectionID"
          when GROUP_NAME
            field = "SMS_Collection.Name"
          else
            print "ERROR - INVALID VALUE"
          end
      end
      query = query + field + " LIKE '%" + value + "%' & "
    }
   
    query = query.chop.chop.chop
    findComputerGroups(query)
  end
  def findComputerGroupsByName(computerGroupName)
    return findComputerGroupsByConditions({ GROUP_NAME => computerGroupName })
  end
  def findComputerGroupsByID(computerGroupID)
    return findComputerGroupsByConditions({ GROUP_ID => computerGroupID })
  end
  def createComputerGroup(name, parentGroup, owner)
    doc = sms_rest_call("createCollection", { "name"                => name,
                                              "parentCollectionID" => parentGroup.remote_id,
                                              "owner"               => owner})
    return SmsComputerGroup.findOrCreate(doc.to_s, self)
  end

  # Computer Functions
  def findComputers(query)
    doc = sms_rest_call("findComputer", {"query" => query})
    searchResponse = doc.elements["smsRestSearchResponse"]
    resultsArray = []
    searchResponse.elements.each("computer") do |computer|
      resultsArray << SmsComputerGroup.findOrCreate(computer.get_text.to_s, self)
    end
    resultsArray
  end
  def findComputersByConditions(conditions)
    query = ""
    conditions.each { |field, value|
      if(field.is_a?(Numeric))          # IF field is numeric, it is using one of the field constants. Translate it to the SMS Equivalent
        case field
        when USER_ID
          field = "SMS_R_System.LastLogonUserName"
        when COMPUTER_NAME
          field = "SMS_R_System.NetbiosName"
        when COMPUTER_SERIAL
          print "ERROR - Cannot Search SMS by Computer Serial Number"
        when COMPUTER_ID
          field = "SMS_R_System.ResourceID"
        else
          print "ERROR - INVALID VALUE"
        end
      end
      query = query + field + " LIKE '%" + value + "%' & "
    }
    query = query.chop.chop.chop
    findComputers(query)  
  end
  def findComputersByUser(userId)
    return findComputersByConditions({ USER_ID => userId })
  end
  def findComputersByName(computerName)
    return findComputersByConditions({ COMPUTER_NAME => computerName })
  end
  def findComputersBySerial(serialNumber)
    return findComputersByConditions({ COMPUTER_SERIAL => serialNumber })
  end
  def findComputersByID(computerID)
    cleanID = computerID.to_i.to_s
    if (cleanID.to_i > 0)
      return findComputersByConditions({ COMPUTER_ID => computerID.to_i.to_s })
    else
      return Array.new()
    end
  end
  
  # Package Functions
  def findPackages(query)
    
    doc = sms_rest_call("findPackage", {"query" => query})
    searchResponse = doc.elements["smsRestSearchResponse"]
    resultsArray = []
    searchResponse.elements.each("package") do |package|
      resultsArray << SmsComputerGroup.findOrCreate(package.get_text.to_s, self)
    end
    resultsArray
  end
  def findPackagesByConditions(conditions)
    query = ""
    conditions.each { |field, value|
      if(field.is_a?(Numeric))          # IF field is numeric, it is using one of the field constants. Translate it to the SMS Equivalent
        case field
          when PACKAGE_ID
            field = "SMS_Package.PackageID"
          when PACKAGE_NAME
            field = "SMS_Package.Name"
          when PACKAGE_MANUFACTURER
            field = "SMS_Package.Manufacturer"
          when PACKAGE_VERSION
            field = "SMS_Package.Version"
          else
            print "ERROR - INVALID VALUE"
          end
      end
      query = query + field + " LIKE '%" + value + "%' AND "
    }
    query = query.chop.chop.chop.chop.chop
    findPackages(query)
  end
  def findPackagesByManufacturerNameAndVersion(manufacturer, name, version)
    return findPackagesByConditions({ PACKAGE_MANUFACTURER  => manufacturer,
                          PACKAGE_NAME          => name,
                          PACKAGE_VERSION       => version})
  end
  def findPackagesByManufacturer(manufacturer)
    return findPackagesByConditions({ PACKAGE_MANUFACTURER  => manufacturer})
  end
  def findPackagesByName(name)
    return findPackagesByConditions({ PACKAGE_NAME          => name})
  end
  def findPackagesByVersion(version)
    return findPackagesByConditions({ PACKAGE_VERSION       => version})
  end
  def findPackagesByID(packageID)
    return findPackagesByConditions({ PACKAGE_ID => packageID })
  end

  # Computer Group Functions
  def findPackageDeployment(query)
    doc = sms_rest_call("findAdvertisement", {"query" => query})
    searchResponse = doc.elements["smsRestSearchResponse"]
    resultsArray = []
    searchResponse.elements.each("advertisement") do |package_deployment|
      resultsArray << SmsComputerGroup.findOrCreate(package_deployment.get_text.to_s, self)
    end
    resultsArray
  end
  def findPackageDeploymentByConditions(conditions)
    query = ""
    conditions.each { |field, value|
      if(field.is_a?(Numeric))          # IF field is numeric, it is using one of the field constants. Translate it to the SMS Equivalent
        case field
          when GROUP_ID
            field = "SMS_Advertisement.CollectionID"
          when PACKAGE_ID
            field = "SMS_Advertisement.PackageID"
          else
            print "ERROR - INVALID VALUE"
          end
      end
      query = query + field + " LIKE '%" + value + "%' & "
    }
   
    query = query.chop.chop.chop
    findPackageDeployment(query)
  end
  def findPackageDeploymentByPackageId(packageId)
    return findPackageDeploymentByConditions({ PACKAGE_ID => packageId })
  end
  def findPackageDeploymentByComputerGroupId(computerGroupID)
    return findPackageDeploymentByConditions({ GROUP_ID => computerGroupID })
  end
  
end
