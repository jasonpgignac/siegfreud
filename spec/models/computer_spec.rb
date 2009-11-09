require 'spec_helper'

describe Computer do
  before(:each) do
    d = mock_model(Division)
    d.stub!(:id) .and_return 1
    d.stub!(:display_name).and_return "Division X (100,101,102)"
    @computer = Computer.new(
        :serial_number  => "1234567",
        :po_number      => "7654321",
        :model          => "Dell Platitudes E9000",
        :system_class   => "PC",
        :division       => d)
        
    @stage = make_a_stage("Storage")
    @stage.save
    @available_stage_1 = make_a_stage("Deployment")
    @available_stage_1.has_location = false
    @available_stage_1.has_deployment = true
    @available_stage_1.save
    @available_stage_2 = make_a_stage("Active")
    @available_stage_2.save
    @unavailable_stage = make_a_stage("Bad Stage")
    @unavailable_stage.save
    @stage.available_stages += [@available_stage_1, @available_stage_2]
  end
  it "should validate when stage.has_location and location field is defined" do
    @computer.stage = @stage
    @computer.location = "Secret Cage"
    @computer.should be_valid
  end
  it "should not validate when stage.has_location and location field is not defined" do
    @computer.stage = @stage
    @computer.should_not be_valid
  end
  it "should validate when stage.has_deployment and deployment fields are defined" do
    @computer.stage = @available_stage_1
    @computer.owner = "lastyfirst"
    @computer.domain = "PEROOT.COM"
    @computer.system_role = "Primary"
    @computer.name = "Computer-1234567"
    @computer.should be_valid
  end
  it "should not validate when stage.has_deployment and owner is not defined" do
    @computer.stage = @available_stage_1
    @computer.domain = "PEROOT.COM"
    @computer.system_role = "Primary"
    @computer.name = "Computer-1234567"
    @computer.should_not be_valid
  end
  it "should not validate when stage.has_deployment and domain is not defined"
  it "should not validate when stage.has_deployment and system_role is not defined"
  it "should not validate when stage.has_deployment and name is not defined"
  describe "#stage_transition_functions" do
    before(:each) do
      @computer.stage = @stage
      @computer.location = "Invisibile Cage"
    end
    describe "#available_stages" do
      it "should return a list of available stages" do
        @computer.available_stages.should == @stage.available_stages
      end
    end
    describe "#valid_change?" do
      it "should return true if the requested stage is in available stages" do
        @computer.valid_change?(@available_stage_1).should == true
      end
      it "should return false if the requested stage is not in available stages" do
        @computer.valid_change?(@unavailable_stage).should == false
      end
    end
  end
  describe "Remote Data Functions" do
    before :each do
      @svc = mock("GenericService")
      @svc2 = mock("GenericService")
    end
    describe "#services_of_type" do
      it "should return a list of services given a service type" do
        Server.should_receive("services_to_match").with("GenericService", "abc.com").and_return([@svc, @svc2])
        results = @computer.services_of_type("GenericService")
        results.should == [@svc, @svc2]
      end
      it "should return a specific services given a service type and server name"
    end
    describe "#get_data_set" do
      it "should get information from all the correct servers"
      it "should get information from a specific server if requested"
    end
  end
end

def make_a_stage(name)
  valid_attributes = {
    :name           => name,
    :has_location   => true,
    :has_deployment => false,
    :is_transitory  => false
  }
  Stage.new(valid_attributes)
end