class RemoveDivisionFromLicense < ActiveRecord::Migration
  def self.up
	remove_column :licenses, :division
  end

  def self.down
	add_column :licenses, :division, :string
  end
end
