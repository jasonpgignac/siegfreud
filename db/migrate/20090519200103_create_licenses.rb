class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table :licenses do |t|
      t.integer   :package_id
      t.integer   :computer_id
      t.string    :po_number
      t.string    :notes
      t.string    :division
      t.timestamps
    end
  end

  def self.down
    drop_table :licenses
  end
end
