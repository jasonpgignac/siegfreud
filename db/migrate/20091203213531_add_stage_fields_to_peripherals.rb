class AddStageFieldsToPeripherals < ActiveRecord::Migration
  def self.up
    add_column :peripherals, :stage_id, :integer
    add_column :peripherals, :location, :string
    add_column :peripherals, :owner, :string
    add_column :peripherals, :description, :string
  end

  def self.down
    remove_column :peripherals, :description
    remove_column :peripherals, :owner
    remove_column :peripherals, :location
    remove_column :peripherals, :stage_id
  end
end
