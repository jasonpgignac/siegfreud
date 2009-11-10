class ChangeTypeColumnToSpecies < ActiveRecord::Migration
  def self.up
	rename_column :servers, :type, :species
  end

  def self.down
	rename_column :servers, :species, :type
  end
end
