class AddLocationToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :location, :string
    add_column :computers, :site, :string
  end

  def self.down
    remove_column :computers, :location
    remove_column :computers, :site
  end
end
