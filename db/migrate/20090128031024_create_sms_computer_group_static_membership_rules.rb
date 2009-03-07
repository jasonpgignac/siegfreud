class CreateSmsComputerGroupStaticMembershipRules < ActiveRecord::Migration
  def self.up
    create_table :sms_computer_group_static_membership_rules do |t|
      t.integer   :computer_group_id
      t.integer   :computer_id
      t.string    :name
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_computer_group_static_membership_rules
  end
end
