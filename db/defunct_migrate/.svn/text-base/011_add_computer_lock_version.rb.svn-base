class AddComputerLockVersion < ActiveRecord::Migration
  def self.up
    add_column :computers, :lock_version, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :computers, :lock_version
  end
end
