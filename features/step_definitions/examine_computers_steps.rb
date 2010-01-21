require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^a computer with serial number (.*)$/ do |serial|
  division = Division.find_by_name("Division X") || Division.create!(
      :name           => "Division X",
      :divisions      => "100,101,102")
      
  stage = Stage.find_by_name("Floating") || Stage.create!(
      :name           => "Floating",
      :has_location   => false,
      :has_deployment => false,
      :is_transitory  => false)
  
  site = Site.find_by_name("Test Site") || Site.create!( :name => "Test Site")
  domain = Domain.find_by_name("test.com") || Domain.create!( :name => "test.com")
  domain = Domain.find_by_name("othertest.com") || Domain.create!( :name => "othertest.com")
  
  @computer = Computer.create!(
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
      :location       => "Under the Bed",
      :site           => site)
    @computer.save
end
Then /^I should see the basic inventory fields$/ do
  response.should contain(@computer.serial_number)
  response.should contain(@computer.model)
  response.should contain(@computer.system_class)
  response.should contain(@computer.po_number)
  response.should contain(@computer.division.display_name)
  response.should contain(@computer.stage.name)
end
Then /^I should see the basic inventory fields for the peripheral$/ do
  response.should contain(@peripheral.serial_number)
  response.should contain(@peripheral.po_number)
  response.should contain(@peripheral.division.display_name)
  response.should contain(@peripheral.model)
end
Given /^the computer is in a stage that offers location information$/ do
  @computer.stage.available_stages << storage_stage
  @computer.stage = storage_stage
  @computer.save
  @computer.should be_valid
end
Given /^the peripheral is in a stage that offers location information$/ do
  @peripheral.stage.available_stages << storage_stage
  @peripheral.stage = storage_stage
  @peripheral.save
  @peripheral.should be_valid
end
Given /^there is a storage stage$/ do
  storage_stage
end
Then /^I should see the location fields$/ do
  response.should contain(@computer.location)
end
Then /^I should not see the location fields$/ do
  response.should_not contain(@computer.location)
end
Then /^I should see the location fields for the peripheral$/ do
  response.should contain(@peripheral.location)
end
Then /^I should not see the location fields for the peripheral$/ do
  response.should_not contain(@peripheral.location)
end
Given /^the computer is in a stage that offers deployment information$/ do
  @computer.stage.has_deployment=true
  @computer.stage.save
end
Given /^the peripheral is in a stage that offers deployment information$/ do
  @peripheral.stage.has_deployment=true
  @peripheral.stage.save
end
Then /^I should see the deployment fields$/ do
  response.should contain(@computer.domain.name)
  response.should contain(@computer.owner)
  response.should contain(@computer.name)
  response.should contain(@computer.system_role)
end
Then /^I should see the deployment fields for the peripheral$/ do
  response.should contain(@peripheral.owner)
  response.should contain(@peripheral.description)
end
Then /^I should not see the deployment fields for the peripheral$/ do
  response.should_not contain(@peripheral.owner)
  response.should_not contain(@peripheral.description)
end
Then /^I should not see the stage field for the peripheral$/ do
  response.should_not contain(@peripheral.stage.name)
end
Then /^I should see the computer information fields for the peripheral$/ do
  response.should contain(@peripheral.computer.short_name)
end
Then /^I should see a button for peripherals$/ do
  response.should contain("Installed Peripherals")
end
Then /^I should see a button for licenses$/ do
  response.should contain("Assigned Licenses")
end
Given /^a stage that does not offer deployment information$/ do
  @computer.stage.has_deployment = false
  @computer.stage.save
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
      :division       => @computer.division,
      :package        => Package.create(
                            :manufacturer => "Apple",
                            :name         => "Pickaxe",
                            :version      => "4.3"),
      :computer       => @computer),
    License.create(
      :po_number      => "3sdf33",
      :license_key    => "ssdfsd",
      :group_license  => false,
      :division       => @computer.division,
      :package        => Package.create(
                            :manufacturer => "Beauford",
                            :name         => "Lord of the Ring Simulator",
                            :version      => "7.5"),
      :computer       => @computer)]
end
Then /^I should see each license$/ do
  @licenses.each do |l|
    response.should contain(l.package.short_name)
    response.should contain(l.license_key)
  end
end
Given /^several attached peripherals$/ do
  @peripheraleripherals = [
    Peripheral.create(
      :po_number      => "347934",
      :serial_number  => "sdbk3343bkj",
      :model          => "Chicken Fried Steak (USB)",
      :division       => @computer.division,
      :computer       => @computer),
      Peripheral.create(
        :po_number      => "347dsf4",
        :serial_number  => "sa2463bkj",
        :model          => "Chicken Fried Steak (Firewire)",
        :division       => @computer.division,
        :computer       => @computer)
  ]
end
Then /^I should see each peripheral$/ do
  @peripheraleripherals.each do |p|
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
                                  :platform   => @computer.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number}}]).domains = [@computer.domain]
  generate_sample_server(   "ServerB", 
                            "http://localhost:8986/", 
                            "ServerType", 
                            [ {   :type       => service_class, 
                                  :platform   => @computer.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number}} ] ).domains = [@computer.domain]
  
end
Given /^(.*) services in the same domain but a different platform$/ do |service_type|
  service_class = service_type.gsub(" ","_").classify
  generate_sample_server(   "ServerA", 
                            "http://nowhere.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => "FakePlatform",
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [@computer.domain]
  generate_sample_server(   "ServerB", 
                            "http://nowhereelse.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => "FakePlatform",
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [@computer.domain]
  
end
Given /^(.*) services in the same platform but a different domain$/ do |service_type|
  service_class = service_type.gsub(" ","_").classify
  domain = Domain.create(:name => "fake.other.domain")
  generate_sample_server(   "ServerA", 
                            "http://nowhere.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => @computer.system_class,
                                  :variables  => {
                                    :computer_key_field => :serial_number} } ] ).domains = [domain]
  generate_sample_server(   "ServerB", 
                            "http://nowhereelse.com/", 
                            "ServerType", 
                            [ {   :type     => service_class, 
                                  :platform => @computer.system_class,
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
  puts "Starting dummy web services..."
  srv1 = start_dummy_web_service(8985,"#{RAILS_ROOT}/tmp/temp_srv1")
  srv2 = start_dummy_web_service(8986,"#{RAILS_ROOT}/tmp/temp_srv2")
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv1/computers/23428.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv1/computers/23428.json", 'w') {|f| f.write(@data1.to_json)}
  FileUtils.makedirs(File.split("#{RAILS_ROOT}/tmp/temp_srv2/computers/23428.json")[0])
  File.open("#{RAILS_ROOT}/tmp/temp_srv2/computers/23428.json", 'w') {|f| f.write(@data2.to_json)}
  sleep 20
  puts "Clicking the link..."
  click_link("computer_information_closed_link")
  puts "Waiting for 20 seconds"
  sleep 20
  puts "Stopping Dummy web services..."
  stop_dummy_web_service(srv1)
  stop_dummy_web_service(srv2)
  puts "Complete"
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

Given /^a (.*) in a stage with \[(.*)\] information with serial number (.*)$/ do |object_type, info_types, serial| 
  
  division = Division.find_by_name("Division X") || Division.new(:name => "Division X")
  division.divisions = "100,101,102"
  division.save
  
  stage = Stage.find_by_name("Stage A") || Stage.new(:name => "Stage A")
  stage.has_location    = info_types.include?("location")
  stage.has_deployment  = info_types.include?("deployment")
  stage.is_transitory   = false
  stage.save
  site = Site.find_by_name("Test Site") || Site.create!( :name => "Site Create")
  domain = Domain.find_or_create_by_name("test.com")
  if object_type == 'computer'
    fields = {
      :serial_number  => serial,
      :po_number      => "7654321",
      :model          => "Dell Platitudes E9000",
      :system_class   => "PC",
      :stage          => stage,
      :division       => division,
      :domain         => (info_types.include?("deployment") ? domain : nil),
      :name           => (info_types.include?("deployment") ? "Comp-#{serial}" : nil),
      :owner          => (info_types.include?("deployment") ? "asmith" : nil),
      :system_role    => (info_types.include?("deployment") ? "Primary" : nil),
      :location       => (info_types.include?("location") ? "Behind the Carwash" : nil),
      :site           => site
    }
    @computer = Computer.create!(fields)
  else
    fields = {
      :serial_number  => serial,
      :po_number      => "7654321",
      :model          => "Dell Monitor 89 inch",
      :stage          => stage,
      :division       => division,
      :owner          => (info_types.include?("deployment") ? "asmith" : nil),
      :description    => (info_types.include?("deployment") ? "Used as a communications satellite" : nil),
      :location       => (info_types.include?("location") ? "Behind the Carwash" : nil)
    }
    @peripheral = Peripheral.create!(fields)
    @peripheral.should be_valid
  end
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
When  /^I wait for (.*) seconds$/ do |time|
  sleep time.to_i
end

When /^I type the (.*) of the (.*) into the search box$/ do |field, type|
  item = case type
  when "computer"
    @computer
  when "peripheral"
    @peripheral
  when "package"
    @package
  end
  value = eval("item.#{field}")
  fill_in('query', :with => value)
end
When /^the system updates the index$/ do
  # Update all indexes
  ThinkingSphinx::Test.index
  sleep(0.25) # Wait for Sphinx to catch up
end
Then /^I should see an entry for the (.*) in the results list$/ do |type|
  item = case type
  when "computer"
    @computer
  when "peripheral"
    @peripheral
  when "package"
    @package
  end
  response.should contain(item.short_name)
end

Given /^a user '(.*)' that has '(.*)' privileges$/ do |name, rights|
  
end
When /^I log in as "(.*)"$/ do |name|
  visit path_to('the login page')
  fill_in(:username, :with => name)
  fill_in(:password, :with => 'Test')
  click_button('Create')
end

Given /^a peripheral with serial number (.*)/ do |serial|
  division = Division.find_by_name("Division X") || Division.create!(
      :name           => "Division X",
      :divisions      => "100,101,102")
      
  stage = Stage.find_by_name("StorageP") || Stage.create!(
      :name           => "StorageP",
      :has_location   => false,
      :has_deployment => false,
      :is_transitory  => false)
  
  @peripheral = Peripheral.create!(
      :serial_number  => serial,
      :po_number      => "7654321",
      :model          => "Dell 897987x17",
      :division       => division,
      :stage          => stage,
      :location       => "Beneath the blue sea",
      :owner          => "UKISSHE",
      :description    => "Currently being used as a paperweight")
  @peripheral.save
end
Given /^a package with name (.*)$/ do |name|
  @package = Package.create(
      :manufacturer   => "Percosoft",
      :name           => name,
      :version        => "7",
      :is_licensed    => true
  )
  @package.should be_valid
end

When /^I follow the link for the (.*)$/ do |type|
  item = case type
  when "computer"
    @computer
  when "peripheral"
    @peripheral
  when "package"
    @package
  end
  click_link(item.short_name)
end
Then /^I should have a tab for the (.*)$/ do |type|
  item = case type
  when "computer"
    @computer
  when "peripheral"
    @peripheral
  when "package"
    @package
  end
  tab_id = "tab-#{item.class.name}-#{item.id}"
  response.should have_selector('#' + tab_id)  
end

When /^I drag the peripheral onto the computer$/ do
  periph_item = 'css=td#' + @peripheral.class.to_s + "_" + @peripheral.id.to_s + ".Peripheral"
  selenium.drag_and_drop_to_object(periph_item, 'css=#computer_peripheral_drop_zone')
end
When /^I drag the package onto the computer$/ do
  pkg_item = 'css=td#' + @package.class.to_s + "_" + @package.id.to_s + ".Package"
  selenium.drag_and_drop_to_object(pkg_item, 'css=#computer_license_drop_zone')
end
Then /^I should see the peripheral listed$/ do
  response.should contain(@peripheral.model + ':' + @peripheral.serial_number)
end
Then /^I should not see the peripheral listed$/ do
  response.should_not contain(@peripheral.model + ':' + @peripheral.serial_number)
end
Then /^I should see the license listed$/ do
  response.should contain(@license.short_name)
end
Then /^I should not see the license listed$/ do
  response.should_not contain(@license.short_name)
end

Then /^the peripheral record should be assigned to the computer$/ do
  @peripheral.reload
  @peripheral.computer_id.should == @computer.id
end
Then /^the peripheral record should not be assigned to the computer$/ do
  @peripheral.reload
  @peripheral.computer_id.should_not == @computer.id
end
Then /^the license record should be assigned to the computer$/ do
  @license.reload
  @license.computer_id.should == @computer.id
end
Then /^there should be record for a computer with serial number "(.*)"$/ do |serial|
  Computer.find_by_serial_number(serial).should_not == nil
end

Then /^there should be a record for a peripheral with serial number "(.*)"$/ do |serial|
  Peripheral.find_by_serial_number(serial).should_not == nil
end
Then /^the license record should not be assigned to the computer$/ do
  @license.reload
  @license.computer_id.should_not == @computer.id
end
When /^the peripheral is in a different division$/ do
  division = Division.find_by_name("Division Y") || Division.create!(
      :name           => "Division Y",
      :divisions      => "103,104,105")
  
  @peripheral.division = division
  @peripheral.save
end
When /^the license is in a different division$/ do
  division = Division.find_by_name("Division Y") || Division.create!(
      :name           => "Division Y",
      :divisions      => "103,104,105")
  
  @license.division = division
  @license.save
end

Given /^a license of package "(.*)" with serial number (.*)$/ do |package_name, serial|
  pkg = Package.find_by_name(package_name)
  division = Division.find_by_name("Division X") || Division.create!(
      :name           => "Division X",
      :divisions      => "100,101,102")
  @license = License.create(
    :license_key    => serial,
    :package        => pkg,
    :po_number      => "32342398", 
    :division       => division
  )
end
When /^I delete the first license$/ do
  @computer.reload
  @license = @computer.licenses.first
  click_link("remove_license_#{@license.id}")
end
When /^I delete the first peripheral$/ do
  @computer.reload
  @peripheral = @computer.peripherals.first
  click_link("remove_peripheral_#{@peripheral.id}")
end

Given /^the peripheral is installed on the computer$/ do
  @peripheral.computer = @computer
  @peripheral.save
end

Given /^a division$/ do
  @division = Division.find_by_name("Division X") || Division.create!(
      :name           => "Division X",
      :divisions      => "100,101,102")
end
Given /^there is a site named "(.*)"$/ do |name|
  @site = Site.find_by_name(name) || Site.create!( :name => name)
end

def storage_stage
  stage = Stage.find_by_name("Storage") || Stage.create!(
      :name           => "Storage",
      :has_location   => true,
      :has_deployment => false,
      :is_transitory  => false)
  return stage
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