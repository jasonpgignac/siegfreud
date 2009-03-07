require 'net/https'
require 'uri'
require 'openssl'
require "rexml/document"

class SmsAdvertisement
  attr_accessor :smsId, :server
  
  def initialize(newID, newServer)
    @smsId = newID
    @server = newServer
  end
  def to_s
    "SMS Advertisement " + self.smsId
  end
  
  def content_id
    self.smsId
  end
  
  def assignNow
    query = URI.escape("AdvertisementId=" + self.smsId)
    url = URI.parse('http://' + self.server.address + "/sms_rest/addAssignmentForNowToAdvertisement.asp?" + query)
    http = Net::HTTP.new(url.host, url.port)
    #http.use_ssl = (url.scheme == 'https')
    http.start do |http|
      req = Net::HTTP::Get.new(url.path + "?" + url.query)
      req.basic_auth(self.server.username, self.server.password)
      res = http.request(req)
      res.body
    end
  end
end
