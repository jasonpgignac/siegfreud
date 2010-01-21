require 'spec_helper'
require 'test_service_type'

describe Audit do
  before :each do 
    @server = Server.create(:name => "Test Server",:species => "Test Type", :address => "http://nowhere.com")
    @service = mock(:service)
    @domain = Domain.create(:name => "test.com")
    @server.domains << @domain
    @site = Site.create(:name => "Poughkeepsie")
    @site_map = SiteMap.create(:server => @server, :site => @site, :remote_site_id => "TestName")
    @audit = Audit.new(:server => @server, :domain => @domain, :site => @site, :platform => "Mac")
    @deployed_stage = Stage.create(:name => "Active", :has_deployment => true, :has_location => false)
    @storage_stage = Stage.create(:name => "Active", :has_deployment => false, :has_location => true)
    @server_data = [
        {"serial_number" => "1", "name" => "C-1", "domain" => "TEST.COM", "user" => "kissingerh"},
        {"serial_number" => "2", "name" => "C-2", "domain" => "TEST.COM", "user" => "kissingerh"},
        {"serial_number" => "5", "name" => "C-5", "domain" => "TEST.COM", "user" => "kissingerh"},
        {"serial_number" => "6", "name" => "C-6", "domain" => "TEST.COM", "user" => "kissingerh"},
        {"serial_number" => "7", "name" => "C-7", "domain" => "TEST.COM", "user" => "kissingerh"},
        {"serial_number" => "8", "name" => "C-8", "domain" => "BAD.COM", "user" => "kissingerh"}
    ]
    @service.stub!(:info_for).with(@site_map).and_return @server_data
    @server.stub!(:service_of_type).with("ComputerInformation","Mac").and_return @service
    
    @db_data = [
      mock_model(Computer, {:serial_number => "1", :name => "C-1", :domain => @domain, :owner => "kissingerh", :stage => @deployed_stage}),
      mock_model(Computer, {:serial_number => "3", :name => "C-3", :domain => @domain, :owner => "kissingerh", :stage => @deployed_stage}),
      mock_model(Computer, {:serial_number => "4", :name => "C-4", :domain => @domain, :owner => "kissingerh", :stage => @storage_stage}),
      mock_model(Computer, {:serial_number => "5", :name => "C-5", :domain => @domain, :owner => "kissingerh", :stage => @storage_stage}),
      mock_model(Computer, {:serial_number => "6", :name => "C-6", :domain => @domain, :owner => "nixonr", :stage => @deployed_stage}),
      mock_model(Computer, {:serial_number => "7", :name => "CX-7", :domain => @domain, :owner => "kissingerh", :stage => @deployed_stage}),
      mock_model(Computer, {:serial_number => "8", :name => "C-8", :domain => @domain, :owner => "kissingerh", :stage => @deployed_stage})
    ]
    Computer.stub!(:find_all_by_site_id).with(@site.id, 
        :conditions => {:system_class => "Mac", :domain_id => @domain.id}).and_return @db_data
  end
  describe "#server_entries" do
    it "should retrieve the data for the given site from the server if necessary" do
      @audit.server_entries.should == @server_data
    end
  end
  describe "#db_entries" do
    it "should retrieve the data for the given site, domain, and platform from the inventory if necessary" do
      Computer.should_receive(:find_all_by_site_id).with(@site.id, 
          :conditions => {:system_class => "Mac", :domain_id => @domain.id}).and_return @db_data
      @audit.db_entries.should == @db_data
    end
  end
  describe "#combined_entries" do
    it "should retrieve a list of entries fro db and server, with the data combined together" do
      @audit.combined_entries.keys.sort.should == ["1","2","3","4","5","6","7","8"]
    end
  end
  describe "#unmatched_server_entries" do
    it "should return a computer in the server entries, if there is no matching serial number in the DB" do
      @audit.unmatched_server_entries.should == [@server_data[1]]
    end
  end
  describe "#unmatched_db_entries" do
    it "should return a comptuer in the database entries, if there is no matching serial number in the server, and the stage is not deployed" do
      @audit.unmatched_db_entries.should == [@db_data[1]]
    end
  end
  describe "#entry_conflicts" do
    it "should not return a computer with matching data, or without a server and db entry" do
      @audit.entry_conflicts.has_key?("1").should == false
      @audit.entry_conflicts.has_key?("2").should == false
      @audit.entry_conflicts.has_key?("3").should == false
      @audit.entry_conflicts.has_key?("4").should == false
    end
    it "should return a computer with an appropriate error if the owner does not match" do
      @audit.entry_conflicts.has_key?("6").should == true
      @audit.entry_conflicts["6"][:errors].should == ["Owner mismatch"]
    end
    it "should return a computer with an appropriate error if the name does not match" do
      @audit.entry_conflicts.has_key?("7").should == true
      @audit.entry_conflicts["7"][:errors].should == ["Name mismatch"]
    end
    it "should return a computer with an appropriate error if the domain does not match" do
      @audit.entry_conflicts.has_key?("8").should == true
      @audit.entry_conflicts["8"][:errors].should == ["Domain mismatch"]
    end
    it "should return a computer with an appropriate error if it is in the server but has not been deployed" do
      @audit.entry_conflicts.has_key?("5").should == true
      @audit.entry_conflicts["5"][:errors].should == ["Deployment status mismatch"]
    end
  end
end