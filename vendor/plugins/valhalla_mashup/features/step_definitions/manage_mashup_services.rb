Given /^an address string (.*)$/ do |address|
  @address = address
end

When /^I define a new mashup service with it$/ do
  @service = Mashup::MashupService.new(@address)
end

Then /^the (\w*) of the mashup service should be (.*)$/ do |field, value|
  url = @service.url
  url.send(field) == value
end

Given /^a mashup service with address (.*)$/ do |address|
  @service = Mashup::MashupService.new(address)
end

When /^I send a (\w*) request to (.*) with parameters {(.*)}$/ do |method, path, parameter_string|
  if parameter_string =~ /^\w*$/
    empty_stub_get_at_path(@service.url, path)
    @response = @service.send(method.downcase, path)
  else
    parameter_string += ","
    params = Hash[*parameter_string.scan(/(.*)\w*=>\w*(.*)\w*,\w/).to_a.flatten]
    empty_stub_get_at_path(@service.url, path, params)
    @response = @service.send(method.downcase, path, params)
  end
end
Then /^the request should return a value of (.*)$/ do |return_code|
  @response.code == return_code
end