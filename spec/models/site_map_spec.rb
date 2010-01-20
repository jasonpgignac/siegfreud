require 'spec_helper'
require 'test_service_type'

describe SiteMap do
  before(:each) do
    @server = Server.create(
      :name     => "TestityServer",
      :species  => "Fasolt",
      :address  => "elsewhere.com"
    )
    @site = Site.create(
      :name   => "Poughkeepsie, New York"
    )
    @site_map = SiteMap.new(
      :site           => @site,
      :server         => @server,
      :remote_site_id => "ID01234"
    )
  end
  
  describe "#validations" do
    it "should validate if the basic data is provided" do
      @site_map.should be_valid
    end
    it "should not validate if there is no server given" do
      @site_map.server = nil
      @site_map.should_not be_valid
    end
    it "should not validate if there is no site given" do
      @site_map.site = nil
      @site_map.should_not be_valid
    end
    it "should not validate if there is no site given" do
      @site_map.remote_site_id = nil
      @site_map.should_not be_valid
    end
  end
  
end