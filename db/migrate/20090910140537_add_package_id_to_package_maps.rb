class AddPackageIdToPackageMaps < ActiveRecord::Migration
  def self.up
	add_column :package_maps, :package_id, :integer
  end

  def self.down
	remove_column :package_maps, :package_id
  end
end
