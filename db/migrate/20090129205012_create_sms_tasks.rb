class CreateSmsTasks < ActiveRecord::Migration
  def self.up
    create_table :sms_tasks do |t|
      t.string    :name
      t.integer   :package_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_tasks
  end
end
