class CreateSmsComputerGroupDynamicMembershipRules < ActiveRecord::Migration
  def self.up
    create_table :sms_computer_group_dynamic_membership_rules do |t|
      t.integer   :computer_group_id
      t.integer   :limiting_computer_group_id
      t.string    :name
      t.string    :query
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_computer_group_dynamic_membership_rules
  end
end
