require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "computers/show.html.erb" do
  before(:each) do
    @computer = stub("Computer")
    assigns[:computer] = @computer
    @computer.stub!(:id).and_return             "1"
    @computer.stub!(:serial_number).and_return  "1234567"
    @computer.stub!(:model).and_return          "Dell Fakety 123"
    @computer.stub!(:system_class).and_return   "Win32"
    @computer.stub!(:mac_address).and_return    "123456789012"
    @computer.stub!(:po_number).and_return      "7654321"
    @computer.stub!(:location).and_return       "Cage"
    @computer.stub!(:owner).and_return          "ugignja"
    @computer.stub!(:domain).and_return         "elsewhere.org"
    @computer.stub!(:name).and_return           "ELSWHERE-1234567"
    @computer.stub!(:system_role).and_return    "Primary"
    @computer.stub_chain(:division, :display_name).and_return "Code (111,222,333)"
    @computer.stub!(:available_stages).and_return %w{ 	Storage
								                                        Rollout
								                                        Active
								                                        Repair
								                                        Retrieval
								                                        Disposal }
  end
  
  it "should display the serial number, model, and platform of the computer" do
    @computer.stub!(:stage).and_return          "Storage"
    
    render "computers/show.html.erb"
    response.should contain(@computer.serial_number)
    response.should contain(@computer.model)
    response.should contain(@computer.system_class)
    response.should contain(@computer.stage)
    response.should contain(@computer.mac_address)
    response.should contain(@computer.po_number)
    response.should contain(@computer.division.display_name)
  end
  it "should display the location data, but not the rollout data if the stage is Disposal" do
    @computer.stub!(:stage).and_return          "Disposal"
    render "computers/show.html.erb"
    response.should contain(@computer.location)
    response.should_not contain(@computer.owner)
    response.should_not contain(@computer.domain)
    response.should_not contain(@computer.name)
    response.should_not contain(@computer.system_role)
  end
  it "should display the rollout data, but not the location data if the stage is Active" do
    @computer.stub!(:stage).and_return          "Active"
    render "computers/show.html.erb"
    response.should_not contain(@computer.location)
    response.should contain(@computer.owner)
    response.should contain(@computer.domain)
    response.should contain(@computer.name)
    response.should contain(@computer.system_role)
  end
  it "should display the rollout data, but not the location data if the stage is Retrieval" do
    @computer.stub!(:stage).and_return          "Retrieval"
    render "computers/show.html.erb"
    response.should contain(@computer.location)
    response.should contain(@computer.owner)
    response.should contain(@computer.domain)
    response.should contain(@computer.name)
    response.should contain(@computer.system_role)
  end
end