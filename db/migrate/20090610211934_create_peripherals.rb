class CreatePeripherals < ActiveRecord::Migration
  def self.up
    create_table :peripherals do |t|
      t.integer   :computer_id
      t.string    :serial_number
      t.string    :po_number
      t.string    :division
      t.string    :model
      t.timestamps
    end
  end

  def self.down
    drop_table :peripherals
  end
end
