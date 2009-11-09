class ChangeOldStageFieldInComputer < ActiveRecord::Migration
  def self.up
	rename_column :computers, :stage, :old_stage
  end

  def self.down
	rename_column :computers, :old_stage, :stage
  end
end
