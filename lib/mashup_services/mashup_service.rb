
class MashupService
  attr_accessor :platform, :address, :domains, :server_name
  
  def post(url, params)
    res = Net::HTTP::post_form(url, params)
    return parse_response(res)
  end
  def get(url)
    puts url.to_s
    req = Net::HTTP::Get.new(url.path + (url.query ? "?#{url.query}":""))
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    raise RemoteRecordNotFound if res.code == "404"
    return parse_response(res)
  end


  def parse_response(res)
    data =  JSON.parse(res.body)
    return data
  end

  def to_s
    "{platform:#{platform}; address:#{address}; domains:#{domains.to_s}; server_name:#{server_name}; class:#{self.class.to_s}"
  end
end

class RemoteRecordNotFound < RuntimeError; end