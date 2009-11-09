class CreateTabsets < ActiveRecord::Migration
  def self.up
    create_table :tabsets do |t|
      t.integer  :active_tab_id;
      t.timestamps;
    end
  end

  def self.down
    drop_table :tabsets
  end
end
