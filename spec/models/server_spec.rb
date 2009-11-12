require 'spec_helper'
require 'test_service_type'
describe Server do
  before :each do
    @server = Server.new
    @server.name = "Test Server"
    @server.species = "TestServerType"
    @server.address = "here.there.com/at_this/"
    
    @server_data = {
      "title" => "Brunhilde",

      "services" => [
          { 
              "type"      => "Test",
              "platform"  =>  "Mac"
          },
          { 
              "type"      => "Test2",
              "platform"  => "Mac"
          }
        ]
    }
    YAML.stub!(:load_file).with("#{RAILS_ROOT}/config/mashups/server_types/TestServerType.yml").and_return(@server_data)
  end
  describe ":validations" do
    it "should validate if all the values are correctly defined" do
      @server.should be_valid
    end
    it "should not validate if name is not defined" do
      @server.name = nil
      @server.should_not be_valid
    end
    it "should not validate if species is not defined" do
      @server.species = nil
      @server.should_not be_valid
    end
    it "should not validate if address is not defined" do
      @server.address = nil
      @server.should_not be_valid
    end
    it "should not validate if name is not unique" do
      @server2 = Server.new
      @server2.name = "Test Server"
      @server2.species = "TestServerType2"
      @server2.address = "here.there.com/at_that/"
      @server2.save
      @server.should_not be_valid
    end
  end
  describe ":service functions" do
    describe ":species description functions" do
      it "should return the species description parsed from the matching yml file" do
        @server.species_description.should == @server_data
      end
      it "should return a list of services from the yml file" do
        @server.services.should == @server_data["services"]
      end
    end
    describe ":contains_service_of_type?" do
      it "should return true if server offers this service" do 
        @server.contains_service_of_type?("Test", "Mac").should == true
      end
      it "should return false if server does not offer this service" do
        @server.contains_service_of_type?("BadServiceType", "Mac").should == false
      end
      it "should return false if server does not off this service for this platform" do
        @server.contains_service_of_type?("Test", "Win32").should == false
      end
    end
    describe ":service_of_type" do
      it "should return a service object if the service exists" do
        svc = mock(ValhallaMashup::TestService)
        ValhallaMashup::TestService.should_receive("new").with(@server.address).and_return(svc)
        svc.should_receive("name=").with(@server.name).and_return(true)
        @server.service_of_type("Test", "Mac").should == svc
        
      end
      it "should throw an exception if the server does not offer this service" do
        lambda{@server.service_of_type("Bad", "Mac")}.should raise_error(RuntimeError)
      end
    end  
  end
end