class CreateSiteMaps < ActiveRecord::Migration
  def self.up
    create_table :site_maps do |t|
      t.integer :site_id
      t.integer :server_id
      t.string :remote_site_id

      t.timestamps
    end
  end

  def self.down
    drop_table :site_maps
  end
end
