require 'spec_helper'

describe Stage do
  before(:each) do
    @valid_attributes = {
      :name => "Storage",
      :has_location => false,
      :has_deployment => false,
      :is_transitory => false
    }
    @stage = Stage.new(@valid_attributes)
  end

  it "should be valid given valid attributes" do
    @stage.should be_valid
  end
  it "should validate presence of name" do 
    @stage.name = nil
    @stage.should_not be_valid
  end
  it "should validate presence of has_location" do 
    @stage.has_location = nil
    @stage.should_not be_valid
  end
  it "should validate presence of has_deployment" do 
    @stage.has_deployment = nil
    @stage.should_not be_valid
  end
  it "should validate presence of is_transitory" do 
    @stage.is_transitory = nil
    @stage.should_not be_valid
  end
  describe "#stage_functions" do
    before(:each) do
      @available_stage_1 = Stage.new(@valid_attributes)
      @available_stage_1.name = "Deployment"
      @available_stage_2 = Stage.new(@valid_attributes)
      @available_stage_2.name = "Active"
      @unavailable_stage = Stage.new(@valid_attributes)
      @unavailable_stage.name = "Bad Stage"
      @stage.save
      @available_stage_1.save
      @available_stage_2.save
      @stage.available_stages << @available_stage_1
      @stage.available_stages << @available_stage_2
    end
    describe "#available_stages" do
      it "should return a list of available stages" do
        @stage.available_stages.should == [@available_stage_1, @available_stage_2]
      end
    end
    
    describe "#valid_change?" do
      it "should return true if offered an available stage" do
        @stage.valid_change?(@available_stage_1).should == true
      end
      it "should return false if offered an unavailable stage" do
        @stage.valid_change?(@unavailable_stage).should == false
      end
    end
  end
end
