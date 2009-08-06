class CreateActionInventoryObjects < ActiveRecord::Migration
  def self.up
    create_table :action_inventory_objects do |t|
      t.integer   :action_id
      t.integer   :inventory_object_id
      t.string    :inventory_object_type
      t.timestamps
    end
  end

  def self.down
    drop_table :action_inventory_objects
  end
end
