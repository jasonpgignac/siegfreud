class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.string :name
      t.boolean :has_location
      t.boolean :has_deployment
      t.boolean :is_transitory

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
