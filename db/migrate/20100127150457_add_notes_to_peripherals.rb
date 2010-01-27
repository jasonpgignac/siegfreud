class AddNotesToPeripherals < ActiveRecord::Migration
  def self.up
    add_column :peripherals, :notes, :string
  end

  def self.down
    remove_column :peripherals, :notes
  end
end
