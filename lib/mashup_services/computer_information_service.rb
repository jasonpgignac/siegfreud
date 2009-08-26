class ComputerInformationService < MashupService
  def path
    self.address + "computers"
  end
  
  def get_info(serial)
    url = URI.parse(self.path + "/#{serial}.json")
    puts "URL: #{url.to_s}"
    computer_record = self.get(url)
  end
  
end