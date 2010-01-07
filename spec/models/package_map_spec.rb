require 'spec_helper'
describe PackageMap do
  before(:each) do
    @package = Package.create(
        :manufacturer   => "Percosoft",
        :name           => "Flummox",
        :version        => "7",
        :is_licensed    => true
    )
    @server = Server.create(
      :name     => "Test Server",
      :species  => "TestServerType",
      :address  => "here.there.com/at_this/"
    )
    @server_data = {
      :title => "Brunhilde",

      :services => [
          { 
              :type       => "Test",
              :platform   =>  "Mac"
          },
          { 
              :type      => "Test2",
              :platform  => "Mac"
          }
        ]
    }
    YAML.stub!(:load_file).with("#{RAILS_ROOT}/config/mashups/server_types/TestServerType.yml").and_return(@server_data)
    @package_map = PackageMap.new(
      :package                => @package,
      :server                 => @server,
      :remote_package_id      => "12345",
      :default_install_task   => "Install",
      :default_uninstall_task => "Uninstall,"
    )      
  end
  describe "#validations" do
    describe "#general" do
      it "should validate given basic settings" do
        @package_map.should be_valid
      end
      it "should not validate if there is no server" do
        @package_map.server = nil
        @package_map.should_not be_valid
      end
      it "should not validate if there is no package" do
        @package_map.package = nil
        @package_map.should_not be_valid
      end
      it "should not validate if there is no remote package id" do
        @package_map.remote_package_id = nil
        @package_map.should_not be_valid
      end
    end
  end
end