class CreateComputers < ActiveRecord::Migration
  def self.up
    create_table  :computers do |t|
      t.string    :name
      t.string    :mac_address
      t.string    :domain
      t.string    :owner
      t.string    :system_role
      t.string    :po_number
      t.string    :model
      t.string    :stage
      t.string    :division
      t.string    :serial_number
      t.string    :system_class
      t.date      :last_audited
      t.timestamps
    end
  end

  def self.down
    drop_table :computers
  end
end
