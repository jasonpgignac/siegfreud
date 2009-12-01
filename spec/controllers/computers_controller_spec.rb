require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ComputersController, "GET show" do
  before :each do
    @c = mock_model(Computer)
    Computer.should_receive(:find_by_serial_number).with("1234567").and_return @c
  end
  it "should find the computer matching the submitted serial number" do
    get :show, :id => "1234567"
  end
  it "should query for remote data if given a service_class parameter" do
    @c.should_receive(:get_data_set).with("ComputerInfo", nil)
    get :show, :id => "1234567", :service_class => "ComputerInfo"
  end
  it "should query for remote data from a single server if given a service_class and service_name parameter" do
    @c.should_receive(:get_data_set).with("ComputerInfo", "fasolt")
    get :show, :id => "1234567", :service_class => "ComputerInfo", :service_name => "fasolt"
  end
end
describe ComputersController, "GET index" do
  it "should find a list of computers matching the given division" do
    Computer.should_receive(:find).with(:all, :conditions => {:division_id => "1"})
    get :index, :division_id => "1"
  end
  it "should find a list of all computers if no division is given" do
    Computer.should_receive(:find).with(:all)
    get :index
  end
  it "should limit the list to a specific stage, if one is given in the query" do
    Computer.should_receive(:find).with(:all, :conditions => {:division_id => "1", :stage_id => "1"})
    get :index, :division_id => "1", :stage_id => "1"
  end
end
describe ComputersController, "DELETE destroy" do
  it "should redirect to index, if submitted in html format" do
    delete :destroy, :id => "1234567", :division_id => "1"
    response.should redirect_to(computers_path)
  end
  it "should delete a computer object" do
    c = mock_model(Computer)
    c.stub!(:destroy).and_return c
    Computer.stub!(:find_by_serial_number).and_return c
    
    Computer.should_receive(:find_by_serial_number).with("1234567")
    c.should_receive(:destroy)
    
    delete :destroy, :id => "1234567", :division_id => "1"
    
    flash[:notice].should == "The computer has been deleted successfully."
  end
  it "should return an error if no object is found and format is html" do
    c = mock_model(Computer)
    c.stub!(:destroy).and_return c
    Computer.stub!(:find_by_serial_number).and_return(nil)
    
    Computer.should_receive(:find_by_serial_number).with("1234567")
    c.should_not_receive(:destroy)
    
    delete :destroy, :id => "1234567", :division_id => "1"
    
    flash[:error].should == "Deletion failed: No computer with the serial number '1234567' could be found"
  end
  it "should return a 404 error if no object is found and format is json" do
    c = mock_model(Computer)
    c.stub!(:destroy).and_return c
    Computer.stub!(:find_by_serial_number).and_return(nil)
    
    delete :destroy, {:id => "1234567", :division_id => "1", :format => "json"}
    response.response_code.should == 404
  end
  it "should return a 404 error if no object is found and format is xml" do
    c = mock_model(Computer)
    c.stub!(:destroy).and_return c
    Computer.stub!(:find_by_serial_number).and_return(nil)
    delete :destroy, {:id => "1234567", :division_id => "1", :format => "xml"}
    response.response_code.should == 404
  end
end
describe ComputersController, "GET edit" do
  it "should find the computer matching the submitted serial number" do
    c = mock_model(Computer)
    Computer.stub!(:find_by_serial_number).and_return c
    Computer.should_receive(:find_by_serial_number).with("1234567")
    get :edit, :id => "1234567"
  end
end
describe ComputersController, "GET new" do
  it "should generate a new computer" do
    c = mock_model(Computer)
    Computer.stub!(:new).and_return c
    Computer.should_receive(:new)
    get :new
  end
end
describe ComputersController, "POST create" do
  before :each do
    @computer_params = {   "field_a"   => "1234567",
                          "field_b"   => "7654321"}
    @c = mock_model(Computer)
    Computer.stub!(:new).and_return @c
    @c.stub!(:serial_number).and_return "1234567"
  end
  it "should create a new object with the submitted parameters and try to save it" do
    @c.stub!(:save).and_return true
    Computer.should_receive(:new).with(@computer_params)
    @c.should_receive(:save)
    post :create, :computer => @computer_params
  end    
  it "should return to the new window if the save fails" do
    @c.stub!(:save).and_return false
    post :create, :computer => @computer_params
    
    response.should redirect_to(new_computer_path)
  end
  it "should go to the show window if the save succeeds" do
    @c.stub!(:save).and_return true
    post :create, :computer => @computer_params
    
    response.should redirect_to(computer_path("1234567"))
  end
end
describe ComputersController, "PUT update" do
  before :each do
    @computer_params = {   "field_a"   => "1234567",
                          "field_b"   => "7654321"}
    @c = mock_model(Computer)
    Computer.stub!(:find_by_serial_number).and_return @c
    @c.stub!(:serial_number).and_return "1234567"
  end
  it "should find the computer matching the given serial number, update it and try to save it" do
    @c.stub!(:update_attributes).and_return true
    
    Computer.should_receive(:find_by_serial_number).with("1234567")
    @c.should_receive(:update_attributes).with(@computer_params)
    
    post :update, :id => "1234567", :computer => @computer_params
  end
  it "should return to the edit window if the save fails" do
    @c.stub!(:update_attributes).and_return false
    
    post :update, :id => "1234567", :computer => @computer_params
    
    response.should redirect_to(edit_computer_path(@c))
  end
  it "should go to the show window if the save succeeds" do
    @c.stub!(:update_attributes).and_return true
    
    post :update, :id => "1234567", :computer => @computer_params
    
    response.should redirect_to(computer_path(@c))
  end
end