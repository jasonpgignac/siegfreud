class SmsComputerGroupStaticMembershipRule < ActiveRecord::Base
  include SmsRestCall
  belongs_to  :computer_group,
              :class_name => "SmsComputerGroup";
  belongs_to  :computer,
              :class_name => "SmsComputer";
  def self.findOrCreate(newComputerGroup, newName, newMember)
    record = self.find( :first, 
                        :conditions => {  :computer_group_id  => newComputerGroup.content_id,
                                          :name               => newName})
    unless(record)
      record = self.new
      record.computer_group = newComputerGroup
      record.name = newName
      record.computer = newMember
      record.save
    end
    return record
  end
  
  def delete
    sms_rest_call("deleteDirectRuleFromCollection", { "id" => computer_group.remote_id,
                                                            "resourceId" => computer.remote_id})
    super
  end
  
  def server
    self.computer_group.server
  end
  def fullQuery
    return "(SMS_R_System.ResourceID" + " LIKE '%" + computer.remote_id + "%')"
  end
  
  def members
    results = Array.new()
    results << computer
    return results
  end
end
