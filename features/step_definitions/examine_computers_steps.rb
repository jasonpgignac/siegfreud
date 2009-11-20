Given /^a computer with serial number (.*)$/ do |serial|
  division = Division.find_by_name("Division X") || Division.create!(
      :name           => "Division X",
      :divisions      => "100,101,102")
      
  stage = Stage.find_by_name("Storage") || Stage.create!(
      :name           => "Storage",
      :has_location   => false,
      :has_deployment => false,
      :is_transitory  => false)
  
  domain = Domain.find_by_name("test.com") || Domain.create!( :name => "test.com")
  
  @c = Computer.create!(
      :serial_number  => serial,
      :po_number      => "7654321",
      :model          => "Dell Platitudes E9000",
      :system_class   => "PC",
      :division       => division,
      :stage          => stage,
      :domain         => domain,
      :name           => "Comp-1234567",
      :owner          => "asmith",
      :system_role    => "primary",
      :location       => "Under the Bed")
    @c.save
end
Then /^I should see the basic inventory fields$/ do
  response.should contain(@c.serial_number)
  response.should contain(@c.model)
  response.should contain(@c.system_class)
  response.should contain(@c.po_number)
  response.should contain(@c.division.display_name)
  response.should contain(@c.stage.name)
end
Given /^a stage that offers location information$/ do
  stage = Stage.create!(
      :name           => "Disposal",
      :has_location   => true,
      :has_deployment => false,
      :is_transitory  => false)
  
  @c.stage = stage
  @c.save
end
Then /^I should see the location fields$/ do
  response.should contain(@c.location)
end
Given /^a stage that offers deployment information$/ do
  @c.stage.has_deployment = true
  @c.stage.save
end
Then /^I should see the deployment fields$/ do
  response.should contain(@c.domain.name)
  response.should contain(@c.owner)
  response.should contain(@c.name)
  response.should contain(@c.system_role)
end
Then /^I should see a button for peripherals$/ do
  response.should contain("Installed Peripherals")
end
Then /^I should see a button for licenses$/ do
  response.should contain("Assigned Licenses")
end
Given /^a stage that does not offer deployment information$/ do
  @c.stage.has_deployment = false
  @c.stage.save
end
Then /^I should not see a button for peripherals$/ do
  response.should_not contain("Installed Peripherals")
end
Then /^I should not see a button for licenses$/ do
  response.should_not contain("Assigned Licenses")
end
Given /^several attached licenses$/ do
  @licenses = [
    License.create(
      :po_number      => "347934",
      :license_key    => "sdbk3343bkj",
      :group_license  => false,
      :division       => @c.division,
      :package        => Package.create(
                            :manufacturer => "Apple",
                            :name         => "Pickaxe",
                            :version      => "4.3"),
      :computer       => @c),
    License.create(
      :po_number      => "3sdf33",
      :license_key    => "ssdfsd",
      :group_license  => false,
      :division       => @c.division,
      :package        => Package.create(
                            :manufacturer => "Beauford",
                            :name         => "Lord of the Ring Simulator",
                            :version      => "7.5"),
      :computer       => @c)]
end
Then /^I should see each license$/ do
  @licenses.each do |l|
    response.should contain(l.package.short_name)
    response.should contain(l.license_key)
  end
end
Given /^several attached peripherals$/ do
  @peripherals = [
    Peripheral.create(
      :po_number      => "347934",
      :serial_number  => "sdbk3343bkj",
      :model          => "Chicken Fried Steak (USB)",
      :division       => @c.division,
      :computer       => @c),
      Peripheral.create(
        :po_number      => "347dsf4",
        :serial_number  => "sa2463bkj",
        :model          => "Chicken Fried Steak (Firewire)",
        :division       => @c.division,
        :computer       => @c)
  ]
end
Then /^I should see each peripheral$/ do
  @peripherals.each do |p|
    response.should contain(p.model)
    response.should contain(p.serial_number)
  end
end
Given /^(.*) services in the same domain and platform$/ do |service_type|
  service_class = service_type.gsub(" ","_").classify
  generate_sample_server(   "ServerA", 
                            "http://localhost:8985/", 
                            "ServerType", 
                            [ {   :type       => service_class, 
                                  :platform   => @c.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number}}]).domains = [@c.domain]
  generate_sample_server(   "ServerB", 
                            "http://localhost:8986/", 
                            "ServerType", 
                            [ {   :type       => service_class, 
                                  :platform   => @c.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number}} ] ).domains = [@c.domain]
  
end
Given /^(.*) services in the same domain but a different platform$/ do |service_type|
  service_class = service_type.gsub(" ","_").classify
  generate_sample_server(   "ServerA", 
                            "http://nowhere.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => "FakePlatform",
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [@c.domain]
  generate_sample_server(   "ServerB", 
                            "http://nowhereelse.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => "FakePlatform",
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [@c.domain]
  
end
Given /^(.*) services in the same platform but a different domain$/ do |service_type|
  service_class = service_type.gsub(" ","_").classify
  domain = Domain.create(:name => "fake.other.domain")
  generate_sample_server(   "ServerA", 
                            "http://nowhere.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => @c.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [domain]
  generate_sample_server(   "ServerB", 
                            "http://nowhereelse.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => @c.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [domain]
end
When /^I click the button to retrieve remote computer information$/ do
  @data1 = {
    "freshness_date"  => "2009-11-13T12:42:20+00:00",
    "domain"          => "MOOKY.COM",
    "mac_addresses"   => ["00:1E:4F:C9:17:A1"],
    "user"            => "hKissinger",
    "name"            => "SAOTXWW-7C1M1G1",
    "ip_addresses"    => ["10.71.220.41"],
    "os"              => "Microsoft Windows NT Workstation 5.1",
    "serial_number"   => "7C1M1G1"
  }
  @data2 = {
    "freshness_date"  => "2008-11-13T12:42:20+00:00",
    "domain"          => "RABBIT.COM",
    "mac_addresses"   => ["00:1E:44:C9:17:A1"],
    "user"            => "lNolan",
    "name"            => "RABBIT-7C1M1G1",
    "ip_addresses"    => ["10.35.220.41"],
    "os"              => "Linux of Happiness",
    "serial_number"   => "7dsdsdgs"
  }
  srv1 = start_dummy_web_service(8985,"#{RAILS_ROOT}/tmp/temp_srv1")
  srv2 = start_dummy_web_service(8986,"#{RAILS_ROOT}/tmp/temp_srv2")
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv1/computers/23428.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv1/computers/23428.json", 'w') {|f| f.write(@data1.to_json)}
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv2/computers/23428.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv2/computers/23428.json", 'w') {|f| f.write(@data2.to_json)}
  
  click_link("computer_information_closed_link")
  sleep 20
  stop_dummy_web_service(srv1)
  stop_dummy_web_service(srv2)
end
When /^I click the button to retrieve remote software management information$/ do
  @data1 = [
      {
        "package_id" => "10000009",
        "task_name"=> "Clear Client Cache",
        "expiration_date"=> "2008-05-02T13:44:00+00:00",
        "comment"=> "This Advertisment will clear the cache on all client systems. It is scheduled to run once every month.\r\nCreated - 11/2/07\r\nJDS",
        "name"=> "Advertisement A",
        "computer_group_id"=> "1000001A",
        "offer_time"=> "2007-11-02T13:44:00+00:00",
        "id"=> "100201A1",
        "will_expire"=> false
      },
      {
        "package_id"=> "00000006",
        "task_name"=> "000 - Dell Warranty",
        "expiration_date"=> "2010-03-03T10:13:00+00:00",
        "comment"=> "CR JDS 9/2/09",
        "name"=> "Advertisement B",
        "computer_group_id"=> "1000001A",
        "offer_time"=> "2009-09-02T10:13:00+00:00",
        "id"=> "10020359",
        "will_expire"=> false
      }
  ]
  @data2 = [
    {
      "package_id"=> "10000009",
      "task_name"=> "Clear Client Cache",
      "expiration_date"=> "2008-05-02T13:44:00+00:00",
      "comment"=> "This Advertisment will clear the cache on all client systems. It is scheduled to run once every month.\r\nCreated - 11/2/07\r\nJDS",
      "name"=> "Advertisement C",
      "computer_group_id"=> "1000001A",
      "offer_time"=> "2007-11-02T13:44:00+00:00",
      "id"=> "100201A1",
      "will_expire"=> false
    },
    {
      "package_id"=> "00000006",
      "task_name"=> "000 - Dell Warranty",
      "expiration_date"=> "2010-03-03T10:13:00+00:00",
      "comment"=> "CR JDS 9/2/09",
      "name"=> "Advertisement D",
      "computer_group_id"=> "1000001A",
      "offer_time"=> "2009-09-02T10:13:00+00:00",
      "id"=> "10020359",
      "will_expire"=> false
    }
  ]
  srv1 = start_dummy_web_service(8985,"#{RAILS_ROOT}/tmp/temp_srv1")
  srv2 = start_dummy_web_service(8986,"#{RAILS_ROOT}/tmp/temp_srv2")
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv1/computers/23432/advertisements.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv1/computers/23432/advertisements.json", 'w') {|f| f.write(@data1.to_json)}
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv2/computers/23432/advertisements.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv2/computers/23432/advertisements.json", 'w') {|f| f.write(@data2.to_json)}
  
  click_link("software_management_closed_link")
  sleep 20
  stop_dummy_web_service(srv1)
  stop_dummy_web_service(srv2)
end
Then /^I should see the computer information from each service$/ do
  [@data1,@data2].each do |data|
    data.each do |key,value|
      if value.is_a?(Enumerable)
        value.each { |inner_value| response.should contain(inner_value) }
      else
        response.should contain(value)
      end
    end
  end
end
Then /^I should see the software management information from each service$/ do
  [@data1,@data2].each do |data|
    data.each do |advert|
      response.should contain(advert['name'])
    end
  end
end

Given /^a computer in a stage with \[(.*)\] information with serial number (.*)$/ do |info_types, serial| 
  
  division = Division.find_by_name("Division X") || Division.new(:name => "Division X")
  division.divisions = "100,101,102"
  division.save
  
  stage = Stage.find_by_name("Stage A") || Stage.new(:name => "Stage A")
  stage.has_location    = info_types.include?("location")
  stage.has_deployment  = info_types.include?("deployment")
  stage.is_transitory   = false
  stage.save
  
  domain = Domain.find_or_create_by_name("test.com")
  
  fields = {
    :serial_number  => serial,
    :po_number      => "7654321",
    :model          => "Dell Platitudes E9000",
    :system_class   => "PC",
    :stage          => stage,
    :division       => division,
    :domain         => (info_types.include?("deployment") ? domain : nil),
    :name           => (info_types.include?("deployment") ? "Comp-1234567" : nil),
    :owner          => (info_types.include?("deployment") ? "asmith" : nil),
    :system_role    => (info_types.include?("deployment") ? "Primary" : nil),
    :location       => (info_types.include?("location") ? "Behind the Carwash" : nil)
  }
  @c = Computer.create!(fields)
end
Given /^a stage is available with \[(.*)\] information$/ do |info_types|
  current_stage = Stage.find_by_name("Stage A")
  
  stage = Stage.find_by_name("Stage B") || Stage.new(:name => "Stage B")
  
  stage.has_location    = info_types.include?("location")
  stage.has_deployment  = info_types.include?("deployment")
  stage.is_transitory   = false
  stage.save
  
  current_stage.available_stages << stage
end

def start_dummy_web_service(port,folder)
  IO.popen("ruby #{RAILS_ROOT}/features/support/dummy_web_server.rb #{port} #{folder}")
end
def stop_dummy_web_service(pipe)
  `kill #{pipe.pid}`
end
def generate_sample_server(name, address, type, services)
  s = Server.find_by_name(name)
  s ||= Server.new(:name => name)
  s.species = type
  s.address = address
  s.save
  
  species = { :title => type, :services => services }
  File.open("#{RAILS_ROOT}/config/mashups/server_types/#{s.species}.yml", 'w') {|f| f.write(species.to_yaml)}
  return s
end