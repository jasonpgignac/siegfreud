class CreateDefaultValuesForComputers < ActiveRecord::Migration
  def self.up
	change_column_default :computers, :stage_id, 1
  end

  def self.down
  end
end
