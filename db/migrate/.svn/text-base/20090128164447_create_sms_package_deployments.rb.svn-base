class CreateSmsPackageDeployments < ActiveRecord::Migration
  def self.up
    create_table :sms_package_deployments do |t|
      t.integer     :computer_group_id
      t.integer     :package_id
      t.string      :program_name
      t.datetime    :expire_date
      t.string      :name
      t.integer     :content_server_id
      t.string      :remote_id
      t.date        :last_cached
      t.date        :last_accessed
      t.timestamps  
    end
  end

  def self.down
    drop_table :sms_package_deployments
  end
end
