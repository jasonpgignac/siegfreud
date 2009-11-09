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
  it "should display a dialog box to select a new development stage, conatining the computer's available choices" do
    @computer.stub!(:stage).and_return          "Storage"
    render "computers/show.html.erb"
    response.should have_selector("select", :name => "stage") do |select|
      select.should have_selector("option", :value => "Storage", :selected => "selected")
      @computer.available_stages.each do |opt|
        select.should have_selector("option", :value => opt)
      end
    end
  end
  it "should display frozen state data if logged in as a user"
  it "should display form for editing fields if logged in as a manager or administrator"
end