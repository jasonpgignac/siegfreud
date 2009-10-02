class AddPackageIdToPackageMaps < ActiveRecord::Migration
  def self.up
        remove_column :package_maps, :package_id
        add_column :package_maps, :package_id, :integer
  end

  def self.down
        remove_column :package_maps, :package_id
        add_column :package_maps, :package_id, :string
  end
end

