class AddNotesToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :notes, :string
  end

  def self.down
    remove_column :computers, :notes
  end
end
