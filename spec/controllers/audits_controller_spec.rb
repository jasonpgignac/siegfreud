require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe AuditsController do
  before :each do 
    Authorization.ignore_access_control(true)
  end
  describe AuditsController, "GET show" do
    before :each do
      @audit = mock_model(Audit)
    end
    it "should create audit" do
      @audit.should_receive(:valid?).and_return true
      Audit.should_receive(:new).with("server_id" => "1", "site_id" => "2", "domain_id" => "3", "platform" => "Win32").and_return @audit
      get :show, :id => "computers", :audit => {:server_id => "1", :site_id => "2", :domain_id => "3", :platform => "Win32"}
    end
    it "should redirect to new if the machine is invalid" do
      @audit.should_receive(:valid?).and_return false
      Audit.should_receive(:new).with("server_id" => "1", "site_id" => "2", "domain_id" => "3").and_return @audit
      get :show, :id => "computers", :audit => {:server_id => "1", :site_id => "2", :domain_id => "3"}
      response.should redirect_to(new_audit_url)
    end
  end
  describe AuditsController, "GET new" do
    it "should get the list of domains, sites, and servers" do
      Server.should_receive(:all).and_return 1
      Domain.should_receive(:all).and_return 2
      Site.should_receive(:all).and_return 3
      get :new
    end
  end
  describe AuditsController, "POST create" do
    it "should redirect to show" do
      post :create, :id => "computers", :server_id => "1", :site_id => "2", :domain_id => "3", :platform => "Win32"
      response.should redirect_to(audit_url("computers"))
    end
  end
end