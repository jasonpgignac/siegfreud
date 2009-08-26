class PackageInformationService < MashupService
  
  def path
    self.address + "/packages"
  end
  
  def get_info(id)
    url = URI.parse(self.path + "/#{id}.json")
    computer_record = self.get(url)
  end

end