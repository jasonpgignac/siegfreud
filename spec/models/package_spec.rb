require 'spec_helper'
require 'test_service_type'
describe Package do
  before(:each) do
    @package = Package.new(
        :manufacturer   => "Percosoft",
        :name           => "Flummox",
        :version        => "7",
        :is_licensed    => true
    )      
  end
  describe "#validations" do
    describe "#general" do
      it "should validate given basic settings" do
        @package.should be_valid
      end
      it "should not validate if there is no name" do
        @package.name = nil
        @package.should_not be_valid
      end
      it "should not validate if there is no manufacturer" do
        @package.manufacturer = nil
        @package.should_not be_valid
      end
      it "should not validate if there is no version" do
        @package.version = nil
        @package.should_not be_valid
      end
    end
  end
  describe "#license_functions" do
    describe "#assigned_licenses" do
      it "should list only licenses that are assigned to a machine" do
        @package.save
        License.should_receive(:find).with(:all, 
                      {
                        :group      => nil, 
                        :having     =>nil, 
                        :limit      =>nil, 
                        :offset     =>nil, 
                        :joins      =>nil, 
                        :include    =>nil, 
                        :select     =>nil, 
                        :readonly   =>nil, 
                        :conditions => "\"licenses\".package_id = #{@package.id} AND (computer_id IS NOT NULL AND computer_id IS NOT '')"
                      }).and_return(["1","2","3"])
        @package.assigned_licenses.should == ["1","2","3"]
      end
      it "should return an empty set if there are no available licenses" do
        @package.save
        License.should_receive(:find).with(:all, 
                      {
                        :group      => nil, 
                        :having     =>nil, 
                        :limit      =>nil, 
                        :offset     =>nil, 
                        :joins      =>nil, 
                        :include    =>nil, 
                        :select     =>nil, 
                        :readonly   =>nil, 
                        :conditions => "\"licenses\".package_id = #{@package.id} AND (computer_id IS NOT NULL AND computer_id IS NOT '')"
                      }).and_return([])
        @package.assigned_licenses.should == []
      end
    end
    describe "#get_open_license" do
      it "should return any open license if no division is specified" do
        @package.save
        License.should_receive(:find).with(:first, 
            {
              :group      => nil, 
              :having     => nil, 
              :limit      => nil, 
              :offset     => nil, 
              :joins      => nil, 
              :include    => nil, 
              :select     => nil, 
              :readonly   => nil, 
              :conditions => "\"licenses\".package_id = #{@package.id} AND (\"licenses\".\"computer_id\" IS NULL)"}).and_return("A")
        @package.get_open_license.should == "A"
      end      
      it "should return an open license within a specific division if division is specified" do
        d = mock_model(Division)
        d.stub!(:id).and_return("12345")
        @package.save
        License.should_receive(:find).with(:first, 
            {
              :group      => nil, 
              :having     => nil, 
              :limit      => nil, 
              :offset     => nil, 
              :joins      => nil, 
              :include    => nil, 
              :select     => nil, 
              :readonly   => nil, 
              :conditions => "\"licenses\".package_id = #{@package.id} AND (\"licenses\".\"computer_id\" IS NULL AND \"licenses\".\"division_id\" = E'#{d.id}')"}).and_return("A")
        @package.get_open_license(d).should == "A"
      end
      it "should return a record not found error if there are no available divisions" do
        @package.save
        License.should_receive(:find).with(:first, 
            {
              :group      => nil, 
              :having     => nil, 
              :limit      => nil, 
              :offset     => nil, 
              :joins      => nil, 
              :include    => nil, 
              :select     => nil, 
              :readonly   => nil, 
              :conditions => "\"licenses\".package_id = #{@package.id} AND (\"licenses\".\"computer_id\" IS NULL)"}).and_return nil
        lambda{@package.get_open_license}.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe "Remote Data Functions" do
    before :each do
      @svr = mock_model(Server,
        :name => "Generic Server A",
        :species => "ServerTypeA")
      
      @svr2 = mock_model(Server,
        :name => "Generic Server B",
        :species => "ServerTypeB")
      
      @svc = mock(ValhallaMashup::TestService)
      @svc.stub!(:address).and_return("http://123.45.67")
      @svc.stub!(:name).and_return("Generic Server A")
      
      @svr.stub!("contains_service_of_type?").with("TestService").and_return(true)
      @svr2.stub!("contains_service_of_type?").with("TestService").and_return(false)
      @svr.stub!("service_of_type").with("TestService").and_return(@svc)
      
      @pm = mock_model(PackageMap, :server => @svr)
      @pm2 = mock_model(PackageMap, :server => @svr2)
      @package.stub!(:package_maps).and_return([@pm,@pm2])
    end
    describe "#servers" do 
      it "should return a list of servers that have been linked" do
        @package.servers.should == [@svr, @svr2]
      end
    end
    describe "#services_of_type" do
      it "should return a list of services given a service type" do
        @package.services_of_type("TestService").should == [@svc]
      end
    end
    describe "#service_of_type_and_name" do
      it "should return a service of given type with a given server name" do
        @package.service_of_type_and_name("TestService", "Generic Server A").should == @svc
      end
      it "should throw a runtime error if there is no matching service" do
        lambda{@package.service_of_type_and_name("TestService", "Generic Server B")}.should raise_error(RuntimeError)
      end
    end
    describe "#get_data_set" do
      before :each do
        @svc.stub(:info_for).with(@package).and_return({:value => "Success!"})                              
      end
      it "should return a hash containing the remote data from a single server, if given a species and name" do
        @package.get_data_set("TestService", "Generic Server A").should == {:value => "Success!"}
      end
      it "should return a hash of hashes with remote data from every server, if given only a species" do
        @package.get_data_set("TestService").should == {"Generic Server A" => {:value => "Success!"}}
      end
    end
  end
end