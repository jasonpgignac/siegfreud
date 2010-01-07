require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe PeripheralsController do
  before :each do 
    Authorization.ignore_access_control(true)
  end
  describe PeripheralsController, "GET show" do
    before :each do
      @p = mock_model(Peripheral)
      Peripheral.should_receive(:find).with("1234567").and_return @p
    end
    it "should find the peripheral" do
      get :show, :id => "1234567"
    end
  end
  describe PeripheralsController, "GET index" do
    it "should find a list of peripherals matching the given division" do
      Peripheral.should_receive(:find).with(:all, :conditions => {:division_id => "1"})
      get :index, :division_id => "1"
    end
    it "should find a list of all peripherals if no division is given" do
      Peripheral.should_receive(:find).with(:all)
      get :index
    end
    it "should limit the list to a specific stage, if one is given in the query" do
      Peripheral.should_receive(:find).with(:all, :conditions => {:division_id => "1", :stage_id => "1"})
      get :index, :division_id => "1", :stage_id => "1"
    end
  end
  describe PeripheralsController, "DELETE destroy" do
    it "should delete a peripheral and redirect to index, if submitted in html format" do
      p = mock_model(Peripheral)
      p.stub!(:destroy).and_return p
      Peripheral.should_receive(:find).with("1234567").and_return p
      delete :destroy, :id => "1234567", :division_id => "1"
      response.should redirect_to(peripherals_path)
    end
    it "should return an error if no object is found and format is html" do
      Peripheral.should_receive(:find).with("1234567").and_return(nil)
      delete :destroy, :id => "1234567", :division_id => "1"
      flash[:error].should == "Deletion failed: No peripheral with the id '1234567' could be found"
    end
    it "should return a 404 error if no object is found and format is json" do
      Peripheral.should_receive(:find).with("1234567").and_return(nil)
      delete :destroy, {:id => "1234567", :division_id => "1", :format => "json"}
      response.response_code.should == 404
    end
    it "should return a 404 error if no object is found and format is xml" do
      Peripheral.should_receive(:find).with("1234567").and_return(nil)
      delete :destroy, {:id => "1234567", :division_id => "1", :format => "xml"}
      response.response_code.should == 404
    end
  end
  describe PeripheralsController, "GET edit" do
    it "should find the peripheral matching the submitted id number" do
      p = mock_model(Peripheral)
      Peripheral.stub!(:find).and_return p
      Peripheral.should_receive(:find).with("1234567")
      get :edit, :id => "1234567"
    end
  end
  describe PeripheralsController, "GET new" do
    it "should generate a new peripheral" do
      p = mock_model(Peripheral)
      Peripheral.stub!(:new).and_return p
      Peripheral.should_receive(:new)
      get :new
    end
  end
  describe PeripheralsController, "POST create" do
    before :each do
      @peripheral_params = {   "field_a"   => "1234567",
                            "field_b"   => "7654321"}
      @p = mock_model(Peripheral)
      Peripheral.stub!(:new).and_return @p
    end
    it "should create a new object with the submitted parameters and try to save it" do
      @p.stub!(:save).and_return true
      Peripheral.should_receive(:new).with(@peripheral_params)
      @p.should_receive(:save)
      post :create, :peripheral => @peripheral_params
    end    
    it "should return to the new window if the save fails" do
      @p.stub!(:save).and_return false
      post :create, :peripheral => @peripheral_params
    
      response.should render_template('new')
    end
    it "should go to the show window if the save succeeds" do
      @p.stub!(:save).and_return true
      post :create, :peripheral => @peripheral_params
    
      response.should redirect_to(peripheral_path(@p))
    end
  end
  describe PeripheralsController, "PUT update" do
    before :each do
      @peripheral_params = {   "field_a"   => "1234567",
                            "field_b"   => "7654321"}
      @p = mock_model(Peripheral)
      Peripheral.stub!(:find).and_return @p
    end
    it "should find the peripheral, update it and try to save it" do
      @p.stub!(:update_attributes).and_return true
      Peripheral.should_receive(:find).with("1234567")
      @p.should_receive(:update_attributes).with(@peripheral_params)
      @p.stub!(:errors).and_return []
      post :update, :id => "1234567", :peripheral => @peripheral_params
    end
    it "should return to the edit window if the save fails" do
      @p.stub!(:update_attributes).and_return false
      @p.stub!(:errors).and_return []
    
      post :update, :id => "1234567", :peripheral => @peripheral_params
    
      response.should render_template('edit')
    end
    it "should go to the show window if the save succeeds" do
      @p.stub!(:update_attributes).and_return true
      @p.stub!(:errors).and_return []
    
      post :update, :id => "1234567", :peripheral => @peripheral_params
    
      response.should redirect_to(peripheral_path(@p))
    end
  end
end