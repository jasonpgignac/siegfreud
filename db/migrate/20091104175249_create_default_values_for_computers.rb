class CreateDefaultValuesForComputers < ActiveRecord::Migration
  def self.up
	  change_column_default :computers, :stage_id, 1
  end

  def self.down
    change_column :computers, :stage_id, :integer, :default => nil
  end
end
