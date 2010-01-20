class AddSiteIdToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :site_id, :integer
  end

  def self.down
    remove_column :computers, :site_id
  end
end
