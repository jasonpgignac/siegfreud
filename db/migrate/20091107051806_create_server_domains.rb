class CreateServerDomains < ActiveRecord::Migration
  def self.up
    create_table :server_domains do |t|
      t.integer :server_id
      t.integer :domain_id

      t.timestamps
    end
  end

  def self.down
    drop_table :server_domains
  end
end
