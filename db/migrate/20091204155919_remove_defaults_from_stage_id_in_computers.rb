class RemoveDefaultsFromStageIdInComputers < ActiveRecord::Migration
  def self.up
    change_column :computers, :stage_id, :integer, :default => nil
  end

  def self.down
    change_column_default :computers, :stage_id, 1
  end
end
