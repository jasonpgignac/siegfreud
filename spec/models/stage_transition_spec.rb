require 'spec_helper'

describe StageTransition do
  before(:each) do
    src = Stage.create!(:name => "Source", :has_location => false, :has_deployment => false, :is_transitory => false)
    dest = Stage.create!(:name => "Destination", :has_location => false, :has_deployment => false, :is_transitory => false)
    valid_attributes = {
      :source => src,
      :destination => dest
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
