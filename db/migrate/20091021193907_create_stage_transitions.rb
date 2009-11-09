class CreateStageTransitions < ActiveRecord::Migration
  def self.up
    create_table :stage_transitions do |t|
      t.integer :source_id
      t.integer :destination_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stage_transitions
  end
end
