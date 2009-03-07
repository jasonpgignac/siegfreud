class CreateComputers < ActiveRecord::Migration
  def self.up
    create_table :computers do |t|
      t.string      :mac_address;
      t.string      :user_id;
      t.date        :audit_date;
      t.timestamps
    end
  end

  def self.down
    drop_table :computers
  end
end
