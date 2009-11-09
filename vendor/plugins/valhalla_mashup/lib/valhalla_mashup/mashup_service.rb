module ValhallaMashup
  require 'open-uri'
  require 'net/http'
  require 'active_support'
  
  class MashupService
    attr_accessor :url, :name
    def initialize(*args)
      if (args.size == 0)
        @url = URI::HTTP.new(nil,nil,nil,nil,nil,nil,nil,nil,nil)
      elsif (args[0].is_a?(String) && args.size == 1)
        @url = URI.parse(args[0])
      else
        raise RuntimeError,"Initialization Error: Unexpected arguments. Must take the form of .new() or .new(String)"
      end
      
    end
    def get(page, query = {})
      req = Net::HTTP::Get.new(generate_child_url(page,query))
      perform_request(req)
    end
    def post(page,data)
      req = Net::HTTP::Post.new(generate_child_url(page))
      req.set_form_data(form_data_from_hash(data))
      perform_request(req)
    end
    def put(page,data)
      req = Net::HTTP::Put.new(generate_child_url(page))
      req.set_form_data(form_data_from_hash(data))
      perform_request(req)
    end
    def delete(page,query = {})
      req = Net::HTTP::Delete.new(generate_child_url(page,query))
      perform_request(req)
    end
    private
    def perform_request(req)
      Net::HTTP.start(url.host, url.port) {|http|
        req.basic_auth url.user, url.password
        res = http.request(req)
        return(JSON.parse(res.body))
      }
    end
    def form_data_from_hash(data)
      new_data = Hash.new
      data.each do |k,v|
        new_data[k.to_s] = v.to_s
      end
      return new_data
    end
    def generate_child_url(page, query = {})
      this_url = url
      this_url.path += page
      this_url.query = query.map {|key, value| "#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"}.join("&")
      this_url.path + (this_url.query != "" ? "?#{url.query}":"")
    end
  end
end
