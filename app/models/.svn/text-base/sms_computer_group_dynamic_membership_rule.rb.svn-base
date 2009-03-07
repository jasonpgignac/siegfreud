class SmsComputerGroupDynamicMembershipRule < ActiveRecord::Base
  belongs_to  :computer_group,
              :class_name => "SmsComputerGroup";
  belongs_to  :limiting_computer_group,
              :class_name => "SmsComputerGroup";
  
  def self.findOrCreate(newComputerGroup, newName, newQuery, limitToCollectionID = nil)
    record = self.find( :first, 
                        :conditions => {  :computer_group_id  => newComputerGroup.content_id,
                                          :name               => newName})
    unless(record)
      record = self.new
      record.computer_group = newComputerGroup
      record.name = newName
      query = newQuery
      record.query = query.split(' where ')[1]
      if (limitToCollectionID && limitToCollectionID != "")
        record.limiting_computer_group = SmsComputerGroup.findOrCreate( limitToCollectionID,
                                                                        record.computer_group.server)
      end
      record.save
    end
    return record
    
  end
  
  def fullQuery
    conditions = Array.new()
    if query
      conditions << query
    end
    if (limiting_computer_group && limiting_computer_group.fullQuery)
      conditions << limiting_computer_group.fullQuery
    end
    if conditions.size > 0
      return "(" + conditions.join(" AND ") + ")"
    else
      return nil
    end
  end
  
  def members
    results = Array.new()
    results = computer_group.server.findComputers(fullQuery)
    return results
  end

end
