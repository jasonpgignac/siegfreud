class CreateBundles < ActiveRecord::Migration
  def self.up
    create_table :bundles do |t|
      t.string      :name
      t.string      :description
      t.timestamps
    end
  end

  def self.down
    drop_table :bundles
  end
end
