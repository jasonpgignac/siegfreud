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
        @url = URI.parse(args.shift)
      elsif (args[0].is_a?(String))
        @url = URI.parse(args.shift)
        params = args[0]
        params.each do |field, value|
          eval("@#{field.to_s} = value")
          puts("!@#{field.to_s} is set to #{value}")
        end
      else
        raise RuntimeError,"Initialization Error: Unexpected arguments. Must take the form of .new() or .new(String, Hash)"
      end
      
    end
    def get(page, query = {})
      begin
        req = Net::HTTP::Get.new(generate_child_url(page,query))
        perform_request(req)
      rescue SocketError
        raise RuntimeError, "Address #{generate_child_url(page,query).to_s} is unavailable"
      end
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
      req.basic_auth url.user, url.password if (url.user && url.password)
      http = Net::HTTP.new(url.host, url.port)
      http.start
      res = http.request(req)
      http.finish
      return(JSON.parse(res.body))
    end
    def form_data_from_hash(data)
      new_data = Hash.new
      data.each do |k,v|
        new_data[k.to_s] = v.to_s
      end
      return new_data
    end
    def generate_child_url(page, query = {})
      this_url = url.clone
      this_url.path += page
      this_url.query = query.map {|key, value| "#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"}.join("&")
      this_url.query = nil if this_url.query == ""
      this_url.to_s
    end
  end
end
