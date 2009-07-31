class CreateBundleMembers < ActiveRecord::Migration
  def self.up
    create_table :bundle_members do |t|
      t.integer   :bundle_id
      t.integer   :package_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bundle_members
  end
end
