class ChangeContentIdFieldInTabToString < ActiveRecord::Migration
  def self.up
    change_column :tabs, :content_id, :string
  end

  def self.down
    change_column :tabs, :content_id, :integer
  end
end
