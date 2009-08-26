
class MashupService
  attr_accessor :platform, :address, :domains, :server_name
  
  def get(url)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    puts "Code: #{res.code}"
    raise RemoteRecordNotFound if res.code == "404"
    return JSON.parse(res.body)
  end
end

class RemoteRecordNotFound < RuntimeError; end