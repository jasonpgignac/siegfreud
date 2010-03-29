class ConvertActionDescriptionToTextField < ActiveRecord::Migration
  def self.up
	change_column :actions, :description, :text
  end

  def self.down
	change_column :actions, :description, :string
  end
end
