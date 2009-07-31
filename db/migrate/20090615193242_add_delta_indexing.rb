class AddDeltaIndexing < ActiveRecord::Migration
  def self.up
    add_column :computers, :delta, :boolean, :default => true, :null => false
    add_column :peripherals, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :computers, :delta
    remove_column :peripherals, :delta
  end
end
