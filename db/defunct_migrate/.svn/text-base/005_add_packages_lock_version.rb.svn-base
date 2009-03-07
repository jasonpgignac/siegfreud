class AddPackagesLockVersion < ActiveRecord::Migration
  def self.up
    add_column :packages, :lock_version, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :packages, :lock_version
  end
end
