class AddDivisionId < ActiveRecord::Migration
  def self.up
	add_column :computers, :division_id, :integer
	add_column :peripherals, :division_id, :integer
	add_column :licenses, :division_id, :integer
  end

  def self.down
	remove_column :computers, :division_id
	remove_column :peripherals, :division_id
	remove_column :licenses, :division_id
  end
end
