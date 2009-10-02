class CreatePackageMaps < ActiveRecord::Migration
  def self.up
    create_table :package_maps do |t|
      t.string :remote_package_id
      t.string :service_name
      t.string :default_install_task
      t.string :default_uninstall_task

      t.timestamps
    end
  end

  def self.down
    drop_table :package_maps
  end
end
