require 'spec_helper'

describe StageTransition do
  before(:each) do
    src = Stage.new(:name => "Source", :has_location => false, :has_deployment => false, :is_transitory => false).save
    dest = Stage.new(:name => "Source", :has_location => false, :has_deployment => false, :is_transitory => false).save
    valid_attributes = {
      :source_id => src,
      :destination_id => dest
    }
    @transition = StageTransition.new(valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    @transition.should be_valid
  end
  it "should validate the presence of a source" do
    @transition.source = nil
    @transition.should_not be_valid
  end
  it "should validate the presence of a destination" do
    @transition.destination = nil
    @transition.should_not be_valid
  end
end
