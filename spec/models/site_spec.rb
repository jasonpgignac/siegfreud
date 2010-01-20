require 'spec_helper'
require 'test_service_type'

describe Site do
  before(:each) do
    @site = Site.new(
      :name   => "Poughkeepsie, New York"
    )
  end
  
  describe "#validations" do
    it "should validate if the basic data is provided" do
      @site.should be_valid
    end
    it "should not validate if there is no name given" do
      @site.name = nil
      @site.should_not be_valid
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
      
      @sm = mock_model(SiteMap, :server => @svr)
      @sm2 = mock_model(SiteMap, :server => @svr2)
      @site.stub!(:servers).and_return([@svr,@svr2])
    end
    describe "#servers" do 
      it "should return a list of servers that have been linked" do
        @site.servers.should == [@svr, @svr2]
      end
    end
    describe "#services_of_type" do
      it "should return a list of services given a service type" do
        @site.services_of_type("TestService").should == [@svc]
      end
    end
    describe "#service_of_type_and_name" do
      it "should return a service of given type with a given server name" do
        @site.service_of_type_and_name("TestService", "Generic Server A").should == @svc
      end
      it "should throw a runtime error if there is no matching service" do
        lambda{@site.service_of_type_and_name("TestService", "Generic Server B")}.should raise_error(RuntimeError)
      end
    end
    describe "#get_data_set" do
      before :each do
        @svc.stub(:info_for).with(@site).and_return({:value => "Success!"})                              
      end
      it "should return a hash containing the remote data from a single server, if given a species and name" do
        @site.get_data_set("TestService", "Generic Server A").should == {:value => "Success!"}
      end
      it "should return a hash of hashes with remote data from every server, if given only a species" do
        @site.get_data_set("TestService").should == {"Generic Server A" => {:value => "Success!"}}
      end
    end
  end
  
end