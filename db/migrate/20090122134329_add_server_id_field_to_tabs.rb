class AddServerIdFieldToTabs < ActiveRecord::Migration
  def self.up
    add_column  :tabs,  :content_server_id, :integer
  end

  def self.down
    remove_column :tabs,  :content_server_id
  end
end
