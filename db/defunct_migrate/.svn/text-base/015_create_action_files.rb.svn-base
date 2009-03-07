class CreateActionFiles < ActiveRecord::Migration
  def self.up
    create_table :action_files do |t|
      t.integer     :action_id
      t.integer     :position
      t.string      :path
      t.boolean     :execute
      t.string      :exec_method
      t.timestamps
    end
  end

  def self.down
    drop_table :action_files
  end
end
