class UserInformationService < MashupService
  def path
    self.address + "/users"
  end
  
  def get_info(username)
    url = URI.parse(self.path + "/#{username}.json")
    computer_record = self.get(url)
  end

end