class PackageInformationService < MashupService
  
  def path
    self.address + "packages"
  end
  
  def get_info(id)
    url = URI.parse(self.path + "/#{id}.json")
    computer_record = self.get(url)
  end

  def search(query)
    url = URI.parse(self.path + ".json?query=#{URI.escape(query)}")
    packages = self.get(url)
  end

  def tasks_for_package(package_id)
    url = URI.parse(self.path + "/#{package_id}/tasks.json")
    tasks = self.get(url)
  end
end