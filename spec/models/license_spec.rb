require 'spec_helper'
require 'test_service_type'
describe License do
  before(:each) do
    @package = Package.create(
        :manufacturer   => "Percosoft",
        :name           => "Flummox",
        :version        => "7",
        :is_licensed    => true
    )
    
    d = mock_model(Division)
    d.stub!(:id) .and_return 1
    d.stub!(:display_name).and_return "Division X (100,101,102)"
    d.stub!(:valid?)
    
    @license = License.new(
        :package        => @package,
        :division       => d,
        :po_number      => "12345",
        :group_license  => false,
        :license_key    => "424123j12k3h1l"
    )
          
  end
  describe "#validations" do
    describe "#general" do
      it "should validate given basic settings" do
        @license.should be_valid
      end
      it "should not validate if there is no package" do
        @license.package = nil
        @license.should_not be_valid
      end
      it "should not validate if there is no division" do
        @license.division = nil
        @license.should_not be_valid
      end
      it "should not validate if there is no po_number" do
        @license.po_number = nil
        @license.should_not be_valid
      end
    end
  end
end