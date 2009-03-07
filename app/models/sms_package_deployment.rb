class SmsPackageDeployment < ActiveRecord::Base
  include SmsObject
  include SmsRestCall
  belongs_to :computer_group,
              :class_name => "SmsComputerGroup"
  belongs_to :package,
              :class_name => "SmsPackage"
  belongs_to :content_server
  
  def delete
    query = URI.escape("id=" + self.remote_id)
    url = URI.parse('http://' + self.server.address + "/sms_rest/deleteAdvertisement.asp?" + query)
    puts url
    http = Net::HTTP.new(url.host, url.port)
    http.start do |http|
      req = Net::HTTP::Get.new(url.path + "?" + url.query)
      req.basic_auth(self.computer_group.server.username, self.computer_group.server.password)
      res = http.request(req)
      puts "Response from package deployment delete : " + res.body.to_s
    end
    super
  end
  def ==(otherSmsPackageDeployment)
    return ((self.remote_id == otherSmsPackageDeployment.remote_id) && (@server == otherSmsPackageDeployment.server))
  end
  
  def to_s
    "SMS Package Deployment " + self.remote_id
  end
  def short_name
    name
  end
  def name
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    else
    end
    super
  end
  def computer_group_id
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    else
    end
    super
  end
  def package_id
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    end
    super
  end
  def program_name
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    else
    end
    super
  end
  def expire_time
    unless (super && ((Date.today - self.last_cached) < 3))
      refreshAttributes
    else
    end
    super
  end
  
  def refreshAttributes
    doc = sms_rest_call("getDetailsForAdvertisement", {"id" => self.remote_id.to_s})
    searchResponse = doc.elements["smsRestAdvertisementRecord"]
    resultsArray = []
    smsTimeZone = searchResponse.elements['timezone'].get_text.to_s.to_i
    self.name = searchResponse.elements['name'].get_text.to_s
    self.computer_group = SmsComputerGroup.find_by_remote_id(searchResponse.elements['collectionid'].get_text.to_s)
    self.package = SmsPackage.find_by_remote_id(searchResponse.elements['packageid'].get_text.to_s)
    self.program_name = searchResponse.elements['programname'].get_text.to_s
    if((searchResponse.elements['expirationtimeenabled'].get_text.to_s) == "True")
      unformatted_expiry = searchResponse.elements['expirationtime'].get_text.to_s
      gmt = (searchResponse.elements['expirationtimeisgmt'].get_text.to_s == 'true')
      self.expire_date = smsTimeToTime(unformatted_expiry, gmt, smsTimeZone)
    end
    searchResponse.elements.each('Schedule') do |schedule|
      unformatted_schedule_time = schedule.get_text.to_s
    end
    self.last_cached = Date.today
    self.save
  end
  
  def assignNow
    query = URI.escape("AdvertisementId=" + self.remote_id)
    url = URI.parse('http://' + self.server.address + "/sms_rest/addAssignmentForNowToAdvertisement.asp?" + query)
    http = Net::HTTP.new(url.host, url.port)
    #http.use_ssl = (url.scheme == 'https')
    http.start do |http|
      req = Net::HTTP::Get.new(url.path + "?" + url.query)
      req.basic_auth(self.server.username, self.server.password)
      res = http.request(req)
      res.body
    end
    refreshAttributes
  end

  private
  
  def smsTimeToTime(smsTime, isGmt, smsTimeZone)
    year = smsTime[0..3]
    month = smsTime[4..5]
    day = smsTime[6..7]
    hour = smsTime[8..9]
    minute = smsTime[10..11]
    expireOffset = isGmt ? 0 : (smsTimeZone * 60)
    return (Time.utc(year, month, day, hour, minute, 0) - expireOffset)
  end

end
