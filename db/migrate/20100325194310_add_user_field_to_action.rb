class AddUserFieldToAction < ActiveRecord::Migration
  def self.up
    add_column :actions, :user, :string
  end

  def self.down
    remove_column :actions, :user
  end
end
