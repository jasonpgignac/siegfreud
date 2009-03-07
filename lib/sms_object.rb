module SmsObject
  module ClassMethods
    
    def findOrCreate(newID, newServer)
      record = self.find(:first, :conditions => {:remote_id          => newID,
                                                 :content_server_id  => newServer.server_id})
      unless(record)
        record = self.new()
        record.remote_id = newID
        record.save
      end
      record.server = newServer
      record.save
      return record
    end
  end
  
  def after_initialize
    
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def server
    @server ||= self.content_server.contentServerObject
  end
  
  def server=(newServer)
    self.content_server_id = newServer.server_id
    @server = newServer
    self.server
  end
  
  def is_refreshing?
    @refresh_thread ? true : false
  end
  
  def refreshAttributes
    unless(is_refreshing?)
      refresh_attributes_now
    else
      wait_for_refresh_to_complete
    end
  end
  
  def wait_for_refresh_to_complete
    puts "Waiting for refresh to complete"
    @refresh_thread.join
    @refresh_thread = nil
  end
end

