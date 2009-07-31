class AddStageChangeDate < ActiveRecord::Migration
  def self.up
    add_column :computers, :last_stage_change, :date
  end

  def self.down
    remove_column :computers, :last_stage_change
  end
end
