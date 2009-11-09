$: << File.join(File.dirname(__FILE__), "/../../lib")
require 'mashup_service'
require 'fakeweb'

# Force all requests in the test environment through here
FakeWeb.allow_net_connect = false

def empty_stub_get(url)
  FakeWeb.register_uri(:get, url, :body => "Success!", :content_type => "text/plain")
end

def unauthorized_stub_get(url)
  FakeWeb.register_uri(:get, url, :body => "Unauthorized", :status => ["401", "Unauthorized"])
end

def empty_stub_get_at_path(url, path, query = {})
  this_url = url.dup
  this_url.path += path
  this_url.query = query.map {|key, value| "#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"}.join("&")
  empty_stub_get(this_url)
  if this_url.user && this_url.password
    this_url.password = this_url.user = nil
    unauthorized_stub_get(this_url)
  end
end