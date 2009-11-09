module ValhallaMashup
class PackageInformationService < MashupService
  
  def path(subpath = nil, format = "json")
    "packages" + (subpath ? "/#{subpath}" : "") + ".#{format}"
  end
  
  def info_for(id)
    computer_record = self.get(self.path(id))
  end

  def search(query)
    packages = self.get(path(),{:query => query})
  end

  def tasks_for_package(id)
    tasks = self.get(path("#{id}/tasks"))
  end
end
end