require 'spec_helper'

describe Peripheral do
  before(:each) do
    d = mock_model(Division)
    d.stub!(:id) .and_return 1
    d.stub!(:display_name).and_return "Division X (100,101,102)"
    d.stub!(:valid?)
    @peripheral = Peripheral.new(
        :serial_number  => "12345678",
        :po_number      => "7654321",
        :model          => "Dell 897987x17",
        :division       => d)
        
    @stage = make_a_stage("Storage")
    @stage.has_location = false
    @stage.has_deployment = false
    @stage.save
    
    @peripheral.stage = @stage
    
    @domain = Domain.new
    @domain.save
  end
  describe "#validations" do
    describe "#general" do
      it "should validate if basic data is provided" do
        @peripheral.should be_valid
      end
      it "should not validate if there is no model defined" do
        @peripheral.model = nil
        @peripheral.should_not be_valid
      end
      it "should not validate if serial number is not unique" do
        d = mock_model(Division)
        d.stub!(:id) .and_return 2
        d.stub!(:display_name).and_return "Division X (100,101,102)"
        d.stub!(:valid?)
        Peripheral.create(
            :serial_number  => @peripheral.serial_number,
            :po_number      => "76567",
            :model          => "Dell 2 897987x17",
            :division       => d,
            :stage          => @stage).should be_valid
        @peripheral.should_not be_valid
      end
      it "should not validate if there is no serial number" do
        @peripheral.serial_number = nil
        @peripheral.should_not be_valid
      end
      it "should not validate if there is no division" do
        @peripheral.division = nil
        @peripheral.should_not be_valid
      end
      it "should not validate if there is no po number" do
        @peripheral.po_number = nil
        @peripheral.should_not be_valid
      end
    end
    describe "#location_data" do
      before :each do
        @stage.has_location = true
        @stage.has_deployment = false
        @peripheral.location = "Secret Cage"
      end
      it "should validate when stage.has_location and location field is defined" do
        @peripheral.should be_valid
      end
      it "should not validate when stage.has_location and location field is not defined" do
        @peripheral.location = nil
        @peripheral.should_not be_valid
      end
    end
    describe "#deployment_data" do
      before :each do
        @stage.has_location = false
        @stage.has_deployment = true
        @peripheral.owner = "lastyfirst"
        @peripheral.description = "This monitor is being used as a paperweight"
      end
      it "should validate when stage.has_deployment and deployment fields are defined" do
        @peripheral.should be_valid
      end
      it "should not validate when stage.has_deployment and owner is not defined" do
        @peripheral.owner = nil
        @peripheral.should_not be_valid
      end
      it "should not validate when stage.has_deployment and description is not defined" do
        @peripheral.description = nil
        @peripheral.should_not be_valid
      end
    end
    describe "#host_system_or_stage" do 
      it "should validate when stage is null and belongs to a valid computer" do
        c = mock_model(Computer)
        c.stub!(:id) .and_return 1
        c.stub!(:division).and_return @peripheral.division
        @peripheral.computer = c
        @peripheral.stage = nil
        @peripheral.should be_valid
      end
      it "should validate when assigned to a stage and does not belong to a valid computer" do
        @peripheral.computer = nil
        @peripheral.should be_valid
      end
      it "should not validate when stage is null and is not assigned to a computer" do
        @peripheral.computer = nil
        @peripheral.stage = nil
        @peripheral.should_not be_valid
      end
    end
  end
  describe "#stage_transition_functions" do
    before(:each) do
      @available_stage_1 = make_a_stage("Deployment")
      @available_stage_1.has_location = false
      @available_stage_1.has_deployment = false
      @available_stage_1.save
      @available_stage_2 = make_a_stage("Active")
      @available_stage_2.save
      @unavailable_stage = make_a_stage("Bad Stage")
      @available_stage_1.has_location = false
      @available_stage_1.has_deployment = false
      @unavailable_stage.save
      @stage.available_stages += [@available_stage_1, @available_stage_2]
    end
    describe "#available_stages" do
      it "should return a list of available stages" do
        @peripheral.available_stages.should == @stage.available_stages
      end
    end
    describe "#valid_change?" do
      it "should return true if the requested stage is in available stages" do
        @peripheral.valid_change?(@available_stage_1).should == true
      end
      it "should return false if the requested stage is not in available stages" do
        @peripheral.valid_change?(@unavailable_stage).should == false
      end
    end
    describe "#transition validations" do
      it "should validate on a legal stage transition" do 
        @peripheral.save
        @peripheral.stage = @available_stage_1
        @peripheral.should be_valid
      end
      it "should not validate on an illegal stage transition" do
        @peripheral.save
        @peripheral.stage = @unavailable_stage
        @peripheral.should_not be_valid
      end
      it "should validate on a transition from any stage to a host computer" do
        c = mock_model(Computer)
        c.stub!(:id) .and_return 1
        c.stub!(:division).and_return @peripheral.division
        
        @peripheral.save
        @peripheral.stage = nil
        @peripheral.computer = c
        @peripheral.should be_valid
      end
      it "should validate on a transition from a host computer to any stage" do
        c = mock_model(Computer)
        c.stub!(:id) .and_return 1
        c.stub!(:division).and_return @peripheral.division
        
        @peripheral.stage = nil
        @peripheral.computer = c
        @peripheral.save
        @peripheral.computer = nil
        @peripheral.stage = @stage
        @peripheral.should be_valid
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