class AddStageIdToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :stage_id, :integer
  end

  def self.down
    remove_column :computers, :stage_id
  end
end
