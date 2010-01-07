class AddIsLicensedToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :is_licensed, :boolean
  end

  def self.down
    remove_column :packages, :is_licensed
  end
end
