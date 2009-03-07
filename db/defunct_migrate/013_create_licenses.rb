class CreateLicenses < ActiveRecord::Migration
  def self.up
    create_table :licenses do |t|
      t.integer     :computer_id
      t.integer     :package_id
      t.date        :purchased_on
      t.string      :po_number
      t.string      :cost_center
      t.timestamps
    end
  end

  def self.down
    drop_table :licenses
  end
end
