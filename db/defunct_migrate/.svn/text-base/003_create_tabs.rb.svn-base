class CreateTabs < ActiveRecord::Migration
  def self.up
    create_table :tabs do |t|
      t.integer     :content_id;
      t.string      :content_type;
      t.integer     :tabset_id;
      t.integer     :position;
      t.boolean     :is_active;
      t.timestamps;
    end
  end

  def self.down
    drop_table :tabs
  end
end
