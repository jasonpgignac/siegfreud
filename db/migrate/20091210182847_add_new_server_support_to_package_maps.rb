class AddNewServerSupportToPackageMaps < ActiveRecord::Migration
  def self.up
    add_column :package_maps, :server_id, :integer
    remove_column :package_maps, :service_name
  end

  def self.down
    add_column :package_maps, :service_name, :string
    remove_column :package_maps, :server_id
  end
end
