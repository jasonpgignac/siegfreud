module SmsRestCall
  require 'ping'
  require 'openssl'
  require 'sms_rest_error'
  attr :url
  
  
  def server_is_available?
    Ping.pingecho(self.server.address, 15)
  end
  
  def sms_rest_call(function, queryParameters = {}) 
    (raise SmsServerUnavailable.new(), "Server " + server.address + " is not answering a ping") unless(server_is_available?)
    url_string = ('http://' + self.server.address + "/sms_rest/" + function + ".asp")
    if queryParameters.size > 0
      query = String.new
      queryParameters.each do |key, value|
        query = query + URI.escape(key + "=" + value.to_s + "&")
      end
      query.chop!
      url_string = url_string +  "?" + query
    end
 
    @url = URI.parse(url_string)
    puts "Executing SMS Rest Function : " + @url.to_s
    http = Net::HTTP.new(@url.host, @url.port)
    http.start do |http|
      req = Net::HTTP::Get.new(@url.path + "?" + @url.query)
      req.basic_auth(self.server.username, self.server.password)
      res = http.request(req)
      process_sms_response_for_errors(res)
      return REXML::Document.new(res.body)
    end
  end
  
  def process_sms_response_for_errors(res)
    error_regex = Regexp.new("(.*)(e|E)rror '(.*)'")
    if(match_data = error_regex.match(res.body.to_s))
      source = match_data[1]
      error_number = match_data[3]
      puts "Source is " + source
      puts "Error Number is " + error_number
      full_error = res.body.to_s
      source_regex = Regexp.new("siegfreud")
      if(source_regex.match(source))
        if error_number == '800a0002'
          raise SmsObjectNotFound.new(@url), full_error;
        elsif error_number == '800a0003'
          raise SmsInvalidQueryParameters.new(@url), full_error;
        elsif error_number == '800a0004'
          raise SmsObjectCreationFailDuplicateName.new(@url), full_error;
        else
          raise SmsGenericRuntimeError.new(@url), full_error;
        end
      else
        raise SmsGenericUnknownError.new(@url), full_error;
      end
    end
  end
end