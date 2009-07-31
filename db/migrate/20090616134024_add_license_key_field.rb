class AddLicenseKeyField < ActiveRecord::Migration
  def self.up
    add_column :licenses, :license_key, :string
    add_column :licenses, :group_license, :boolean
  end

  def self.down
    remove_column :licenses, :license_key
    remove_column :licenses, :group_license
  end
end
