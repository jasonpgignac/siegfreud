require 'spec_helper'

describe Computer do
  before(:each) do
    d = mock_model(Division)
    d.stub!(:id) .and_return 1
    d.stub!(:display_name).and_return "Division X (100,101,102)"
    d.stub!(:valid?)
    @computer = Computer.new(
        :serial_number  => "1234567",
        :po_number      => "7654321",
        :model          => "Dell Platitudes E9000",
        :system_class   => "PC",
        :division       => d)
        
    @stage = make_a_stage("Storage")
    @stage.has_location = false
    @stage.has_deployment = false
    @stage.save
    
    @computer.stage = @stage
    
    @domain = Domain.new
    @domain.save
  end
  describe "#validations" do
    describe "#general" do
      it "should validate if basic data is provided" do
        @computer.should be_valid
      end
      it "should not validate if there is no stage defined" do
        @computer.stage = nil
        @computer.should_not be_valid
      end
      it "should not validate if there is no division defined" do
        @computer.division = nil
        @computer.should_not be_valid
      end
    end
    describe "#location_data" do
      before :each do
        @stage.has_location = true
        @stage.has_deployment = false
        @computer.location = "Secret Cage"
      end
      it "should validate when stage.has_location and location field is defined" do
        @computer.should be_valid
      end
      it "should not validate when stage.has_location and location field is not defined" do
        @computer.location = nil
        @computer.should_not be_valid
      end
    end
    describe "#deployment_data" do
      before :each do
        @stage.has_location = false
        @stage.has_deployment = true
        @computer.owner = "lastyfirst"
        @computer.domain = @domain
        @computer.system_role = "Primary"
        @computer.name = "Computer-1234567"
      end
      it "should validate when stage.has_deployment and deployment fields are defined" do
        @computer.should be_valid
      end
      it "should not validate when stage.has_deployment and owner is not defined" do
        @computer.owner = nil
        @computer.should_not be_valid
      end
      it "should not validate when stage.has_deployment and domain is not defined" do
        @computer.domain = nil
        @computer.should_not be_valid
      end
      it "should not validate when stage.has_deployment and system_role is not defined" do
        @computer.system_role = nil
        @computer.should_not be_valid
      end
      it "should not validate when stage.has_deployment and name is not defined" do
        @computer.name = nil
        @computer.should_not be_valid
      end
    end
  end
  describe "#stage_transition_functions" do
    before(:each) do
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
      @computer.stage = @available_stage_1
      @computer.owner = "lastyfirst"
      @computer.domain = @domain
      @computer.system_role = "Primary"
      @computer.name = "Computer-1234567"
      @computer.save
      
      @svc = mock_model(Server,
        :name => "Generic Server A",
        :species => "ServerTypeA")
      
      @svc2 = mock_model(Server,
        :name => "Generic Server B",
        :species => "ServerTypeB")
      @computer.stub!(:servers).and_return([@svc, @svc2])
      
    end
    describe "#services_of_type" do
      it "should return a list of services given a service type" do
        @svc.should_receive("contains_service_of_type?").with("GenericService", "PC").and_return(true)
        @svc2.should_receive("contains_service_of_type?").with("GenericService", "PC").and_return(false)
        @svc.should_receive("service_of_type").with("GenericService", "PC").and_return("SERVICE HERE")
        results = @computer.services_of_type("GenericService")
        results.should == ["SERVICE HERE"]
      end
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