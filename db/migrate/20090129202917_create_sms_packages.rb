class CreateSmsPackages < ActiveRecord::Migration
  def self.up
    create_table :sms_packages do |t|
      t.string      :remote_id
      t.string      :manufacturer
      t.string      :version
      t.integer     :content_server_id
      t.string      :name
      t.date        :last_cached
      t.date        :last_accessed
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_packages
  end
end
