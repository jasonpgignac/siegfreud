class SmsComputer < ActiveRecord::Base
  include SmsRestCall
  include SmsObject
  extend SmsObjectClassMethods
  
  
  belongs_to :content_server;
  
  def ==(otherSmsComputer)
    return ((self.remote_id == otherSmsComputer.remote_id) && (@server == otherSmsComputer.server))
  end
  
  def to_s
    "SMS Computer " + self.remote_id.to_s
  end
  def short_name
    name + ":(" + user + ")"
  end
  def name
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    end
    super
  end
  def user
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    end
    super
  end
  def content_id
    self.remote_id
  end
  
  def refresh_attributes_now
    doc = sms_rest_call("getDetailsForComputer", {"id" => self.remote_id.to_s})
    searchResponse = doc.elements["smsRestComputerRecord"]
    resultsArray = []
    self.name = searchResponse.elements['name'].get_text.to_s
    self.user = searchResponse.elements['user'].get_text.to_s
    self.last_cached = Date.today
    self.save
  end
  def template_class
    return "computer"
  end
  
end
