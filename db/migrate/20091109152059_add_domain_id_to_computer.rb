class AddDomainIdToComputer < ActiveRecord::Migration
  def self.up
    add_column :computers, :domain_id, :integer
  end

  def self.down
    remove_column :computers, :domain_id
  end
end
