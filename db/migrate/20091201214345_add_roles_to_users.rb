class AddRolesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean
    add_column :users, :technician, :boolean
    add_column :users, :reporter, :boolean
  end

  def self.down
    remove_column :users, :reporter
    remove_column :users, :technician
    remove_column :users, :admin
  end
end
