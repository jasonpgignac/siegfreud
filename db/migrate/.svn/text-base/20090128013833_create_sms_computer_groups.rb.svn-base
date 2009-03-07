class CreateSmsComputerGroups < ActiveRecord::Migration
  def self.up
    create_table :sms_computer_groups do |t|
      t.string    :remote_id
      t.integer   :content_server_id
      t.string    :name
      t.date      :last_cached
      t.date      :last_accessed
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_computer_groups
  end
end
