class ContentServer < ActiveRecord::Base

  def self.content_store=(store)
    @@content_store = store
  end
  
  def contentServerObject()
    if self.server_type == "SMS"
      serverObject = SmsServer.new
    end
    serverObject.address = self.address
    if @@content_store[self.id]
      serverObject.username = @@content_store[self.id][:username]
      serverObject.password = @@content_store[self.id][:password]
    else  
      serverObject.username = @@content_store[:default][:username]
      serverObject.password = @@content_store[:default][:password]
    end
    serverObject.server_id = self.id
    serverObject.server_name = self.name
    return serverObject
  end
  
end
