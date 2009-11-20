require File.join(File.dirname(__FILE__), "/../spec_helper")
module ValhallaMashup
  describe MashupService do
    context "a new record" do
      it "should generate an empty URL if there are no parameters" do
        mashup = MashupService.new()
        mashup.url.host.should.nil?
      end
      it "should generate a URI object with a url string" do
        mashup = MashupService.new("http://user:pass@test.com/test/path/")
        mashup.url.host.should == "test.com"
        mashup.url.user.should == "user"
        mashup.url.password.should == "pass"
        mashup.url.path.should == "/test/path/"
      end
      it "should set other variables, if they are included as parameters"
    end
    context "a generic server" do
      before(:each) do
        @mashup = MashupService.new("http://user:pass@test.com:1234/")
      end
      it "should be able to submit a successful GET request" do
        empty_stub(:get,"http://user:pass@test.com:1234/index.html")
        res = @mashup.get("index.html")
      end
      it "should be able to submit a successful GET request with query parameters" do
        empty_stub(:get, 'http://user:pass@test.com:1234/index.json?field1=Test%20Value&field2=Test%20Value%202')
        res = @mashup.get("index.json", {:field1 => "Test Value", :field2 => "Test Value 2"})
      end
      it "should be able to retrieve data from a GET request" do
        novel_list = {  "Charlotte Bronte"  => ['Jane Eyre','Vilette','Shirley'],
                        "Emily Bronte"      => ['Wuthering Heights'],
                        "Anne Bronte"       => ['Agens Grey','Tenant of Wildfell Hall']}
        empty_stub(:get,'http://user:pass@test.com:1234/index.json?field1=Test%20Value&field2=Test%20Value%202', novel_list)
        res = @mashup.get("index.json", {:field1 => "Test Value", :field2 => "Test Value 2"})
        res.should == novel_list
      end
      it "should be able to retrieve data from a POST request" do
        novel_list = {  "Charlotte Bronte"  => ['Jane Eyre','Vilette','Shirley'],
                        "Emily Bronte"      => ['Wuthering Heights'],
                        "Anne Bronte"       => ['Agens Grey','Tenant of Wildfell Hall']}
        empty_stub(:post,'http://user:pass@test.com:1234/index.json', novel_list)
        res = @mashup.post("index.json", {:test1 => "Test Value", :test2 => "Test Value 2"})
        res.should == novel_list
      end
      it "should be able to retrieve data from a PUT request" do
        novel_list = {  "Charlotte Bronte"  => ['Jane Eyre','Vilette','Shirley'],
                        "Emily Bronte"      => ['Wuthering Heights'],
                        "Anne Bronte"       => ['Agens Grey','Tenant of Wildfell Hall']}
        empty_stub(:put,'http://user:pass@test.com:1234/index.json', novel_list)
        res = @mashup.put("index.json", {:test1 => "Test Value", :test2 => "Test Value 2"})
        res.should == novel_list
      end
      it "should be able to retrieve data from a DELETE request" do  
        novel_list = {  "Charlotte Bronte"  => ['Jane Eyre','Vilette','Shirley'],
                        "Emily Bronte"      => ['Wuthering Heights'],
                        "Anne Bronte"       => ['Agens Grey','Tenant of Wildfell Hall']}
        empty_stub(:delete,'http://user:pass@test.com:1234/index.json?test1=Test%20Value&test2=Test%20Value%202', novel_list)
        res = @mashup.delete("index.json", {:test1 => "Test Value", :test2 => "Test Value 2"})
        res.should == novel_list
      end
    end
  end
  describe ComputerInformationService do
    context "a generic server" do
      before(:each) do
        @mashup = ComputerInformationService.new("http://user:pass@test.com/", :computer_key_field => :serial_number)
        @sample_computer_data = {
          "domain"          => "PEROOT",
          "ip_addresses"    => ["10.133.220.41"],
          "freshness_date"  => "2009-10-09T12:42:21+00:00",
          "user"            => "UGignJa",
          "serial_number"   => "7C1M1G1",
          "name"            => "SAOTXWW-7C1M1G1",
          "mac_addresses"   => ["00:1E:4F:C9:17:A1"],
          "os"              => "Microsoft Windows NT Workstation 5.1"
        }
        @sample_computer = mock('Computer')
        @sample_computers = [
          {
            "domain"        => "PEROOT",
            "ip_addresses"  => ["10.133.220.100"],
            "freshness_date"=> "2009-10-09T00:00:01+00:00",
            "user"          => "umartar",
            "serial_number" => "7M3PJD1",
            "name"          => "SAOTXWW-7M3PJD1",
            "mac_addresses" => ["00:1A:A0:BA:56:6D"]
          },
          {
            "domain"=> "PEROOT",
            "ip_addresses"=> [
              "10.133.220.59"
            ],
            "freshness_date"=> "2009-10-09T10:32:00+00:00",
            "user"=> "umartar",
            "serial_number"=> "8303KC1",
            "name"=> "SAOTXWW-1621562",
            "mac_addresses"=> [
              "00:19:B9:16:D8:C7"
            ]
          }
        ]
      end
      it "should return computer information given a computer object" do
        empty_stub(:get,'http://user:pass@test.com/computers/1234567.json', @sample_computer_data)
        @sample_computer.should_receive(:serial_number).and_return("1234567")
        res = @mashup.info_for(@sample_computer)
        res.should == @sample_computer_data
      end
      it "should return a list of computers given a query" do
        empty_stub(:get,'http://user:pass@test.com/computers.json?query=umartar', @sample_computers)
        res = @mashup.search("umartar")
        res.should == @sample_computers
      end
      it "should throw a runtime error if a computer is created without a key field defined" do 
        lambda{ComputerInformationService.new("http://user:pass@test.com/")}.should raise_error(RuntimeError)
      end
    end
  end
  describe SoftwareManagementService do
    context "a generic server" do
      before(:each) do
        @mashup = SoftwareManagementService.new("http://user:pass@test.com/")
        @package = {
          "package_id" => "100000FB",
          "task_name" => "Install Silently",
          "expiration_date" => "2009-09-16T18:39:00+00:00",
          "comment" => "",
          "name" => "siegfreud push 2009-09-16T13:39:27-05:00",
          "computer_group_id" => "10000356",
          "offer_time" => "2009-09-16T13:39:00+00:00",
          "will_expire" =>false,
          "id" => "10020370"
        }
        @packages = [
          {
            "package_id" => "00000002",
            "task_name" => "000 - Software: WSUS UPG",
            "expiration_date" => "2010-01-31T15:03:00+00:00",
            "comment" => "To Upgrade the WSUS client CR 8/1/09 JDS",
            "name" => "000 - WSUS CLient Upgrade to All Client Systems",
            "computer_group_id" => "0000000E",
            "offer_time" => "2009-08-02T15:03:00+00:00",
            "will_expire" =>true,
            "id" => "00020000"
          },
          {
            "package_id" => "10000009",
            "task_name" => "Clear Client Cache",
            "expiration_date" => "2008-05-02T13:44:00+00:00",
            "comment" => "This Advertisment will clear the cache on all client systems. It is scheduled to run once every month.\r\nCreated - 11/2/07\r\nJDS",
            "name" => "Global - SMS Client - Clear Cache",
            "computer_group_id" => "1000001A",
            "offer_time" => "2007-11-02T13:44:00+00:00",
            "will_expire" =>false,
            "id" => "100201A1"
          },
          {
            "package_id" => "00000006",
            "task_name" => "000 - Dell Warranty",
            "expiration_date" => "2010-03-03T10:13:00+00:00",
            "comment" => "CR JDS 9/2/09",
            "name" => "100 - Dell Warranty",
            "computer_group_id" => "1000001A",
            "offer_time" => "2009-09-02T10:13:00+00:00",
            "will_expire" =>false,
            "id" => "10020359"
          },
          {
            "package_id" => "00000002",
            "task_name" => "000 - Software: WSUS UPG",
            "expiration_date" => "1990-01-01T00:00:00+00:00",
            "comment" => "CR 7/28/09 JDS",
            "name" => "000 - WSUS CLient Upgrade - San Antonio TX",
            "computer_group_id" => "100001A2",
            "offer_time" => "2009-07-27T10:12:00+00:00",
            "will_expire" =>false,
            "id" => "1002033A"
          },
          {
            "package_id" => "100000FB",
            "task_name" => "Install Silently",
            "expiration_date" => "2009-09-16T18:36:00+00:00",
            "comment" => "",
            "name" => "siegfreud push 2009-09-16T13:35:47-05:00",
            "computer_group_id" => "10000355",
            "offer_time" => "2009-09-16T13:36:00+00:00",
            "will_expire" =>false,
            "id" => "1002036F"
          },
          {
            "package_id" => "100000FB",
            "task_name" => "Install Silently",
            "expiration_date" => "2009-09-16T18:39:00+00:00",
            "comment" => "",
            "name" => "siegfreud push 2009-09-16T13:39:27-05:00",
            "computer_group_id" => "10000356",
            "offer_time" => "2009-09-16T13:39:00+00:00",
            "will_expire" =>false,
            "id" => "10020370"
          },
          {
            "package_id" => "100000FB",
            "task_name" => "Install Silently",
            "expiration_date" => "2009-09-30T18:42:00+00:00",
            "comment" => "",
            "name" => "siegfreud push 2009-09-16T13:42:45-05:00",
            "computer_group_id" => "10000357",
            "offer_time" => "2009-09-16T13:42:00+00:00",
            "will_expire" =>true,
            "id" => "10020371"
          },
          {
            "package_id" => "100000FB",
            "task_name" => "Install Silently",
            "expiration_date" => "2009-09-30T20:45:00+00:00",
            "comment" => "",
            "name" => "siegfreud push 2009-09-16T15:45:44-05:00",
            "computer_group_id" => "10000358",
            "offer_time" => "2009-09-16T15:45:00+00:00",
            "will_expire" =>true,
            "id" => "10020372"
          },
          {
            "package_id" => "100000FB",
            "task_name" => "Install Silently",
            "expiration_date" => "2009-09-30T20:46:00+00:00",
            "comment" => "",
            "name" => "siegfreud push 2009-09-16T15:45:56-05:00",
            "computer_group_id" => "10000359",
            "offer_time" => "2009-09-16T15:46:00+00:00",
            "will_expire" => true,
            "id" => "10020373"
          }
        ]
      end
      it "should be a child object of PackageInformationService"
      it "should return a list of assignments, given a computer name" do
        empty_stub(:get,'http://user:pass@test.com/computers/1234567/advertisements.json', @packages)
        res = @mashup.advertisements_for_computer("1234567")
        res.should == @packages
      end
      it "should push a package to a given computer" do 
        empty_stub(:post,'http://user:pass@test.com/computers/1234567/advertisements.json', @package)
        res = @mashup.push_task_to_computer("100000FB", "Install Silently", "1234567")
        res.should == @package
      end
    end
  end
  describe PackageInformationService do
    context "a generic server" do
      before(:each) do
        @mashup = PackageInformationService.new("http://user:pass@test.com/")
        @package = {
          "freshness_date" => "2009-08-14T17:49:25+00:00",
          "name" => "Acrobat Pro",
          "version" => "7",
          "description" => "",
          "manufacturer" => "109 Adobe",
          "id" => "100000FB"
        }
        @packages = [
          {
            "freshness_date" =>"2009-03-23T14:15:03+00:00",
            "name" =>"Reader",
            "version" =>"9.0",
            "description" =>"AM",
            "manufacturer" =>"109 Adobe Acrobat",
            "id" =>"10000121"
          },
          {
            "freshness_date" =>"2009-08-14T17:50:56+00:00",
            "name" =>"Acrobat Pro",
            "version" =>"8",
            "description" =>"AM (1/13/09)",
            "manufacturer" =>"109 Adobe",
            "id" =>"10000108"
          },
          {
            "freshness_date" =>"2009-10-02T14:50:32+00:00",
            "name" =>"100 - Software: Adobe Acrobat 9 Pro",
            "version" =>"",
            "description" =>"Installation of Adobe Acrobat 9 Pro for Tareq Mansour to machines in 345 & 375 - Created 10/2/2009 - TR",
            "manufacturer" =>"",
            "id" =>"1000014F"
          },
          {
            "freshness_date" =>"2009-10-02T13:02:06+00:00",
            "name" =>"100 - Software: Adobe Acrobat 9 Pro Pilot",
            "version" =>"",
            "description" =>"",
            "manufacturer" =>"",
            "id" =>"1000014E"
          },
          {
            "freshness_date" =>"2009-08-14T17:49:25+00:00",
            "name" =>"Acrobat Pro",
            "version" =>"7",
            "description" =>"",
            "manufacturer" =>"109 Adobe",
            "id" =>"100000FB"
          },
          {
            "freshness_date" =>"2009-08-14T17:51:33+00:00",
            "name" =>"Acrobat Pro",
            "version" =>"9",
            "description" =>"AM (5/13/09)",
            "manufacturer" =>"109 Adobe",
            "id" =>"100000F6"
          }
        ]
        @tasks = [
          {
            "command" =>"Acropro.msi TRANSFORMS=AcroPro7.mst /qn",
            "comment" =>"12/4/08 - JG - Initial creation",
            "name" =>"Install Silently",
            "id" =>"Install Silently"
          },
          {
            "command" =>"MsiExec.exe /x{AC76BA86-1033-0000-7760-100000000002} /qn",
            "comment" =>"AM 08/03/09",
            "name" =>"Uninstall Silently",
            "id" =>"Uninstall Silently"
          }
        ]
      end
      it "should be a child object of ComputerInformationService"
      it "should return data on a given package" do
        empty_stub(:get, 'http://user:pass@test.com/packages/100000FB.json', @package)
        res = @mashup.info_for("100000FB")
        res.should == @package
      end
      it "should return data on a list of machines, given a search string" do 
        empty_stub(:get, 'http://user:pass@test.com/packages.json?query=Acrobat', @packages)
        res = @mashup.search("Acrobat")
        res.should == @packages
      end
      it "should return a list of tasks, given a package" do 
        empty_stub(:get, 'http://user:pass@test.com/packages/100000FB/tasks.json', @tasks)
        res = @mashup.tasks_for_package("100000FB")
        res.should == @tasks
      end
    end
  end
  describe UserInformationService do
    context "a generic server" do
      before(:each) do
        @mashup = UserInformationService.new("http://user:pass@test.com/")
        @user = {
          "user_login" =>"UGignJa",
          "name" =>"Gignac, Jason (HAS-SAT)",
          "email_addresses" =>"Jason.Gignac@Pearson.com",
          "path" =>{
            "rdns" =>[
              {
                "cn" =>"Gignac, Jason (HAS-SAT)"
              },
              {
                "OU" =>"Users"
              },
              {
                "OU" =>"San Antonio, TX"
              },
              {
                "OU" =>"United States"
              },
              {
                "OU" =>"North America"
              },
              {
                "OU" =>"School Group"
              },
              {
                "dc" =>"peroot"
              },
              {
                "dc" =>"com"
              }
            ]
          },
          "cost_center" =>"10515",
          "division" =>"150",
          "description" => nil
        }
      end
      it "should return data on a given user" do
        empty_stub(:get, 'http://user:pass@test.com/users/ugignja.json', @user)
        res = @mashup.info_for("ugignja")
        res.should == @user
      end
    end
  end
end
