module ValhallaMashup
  class ComputerInformationService < MashupService
    def path(subpath = nil, format = "json")
      "computers" + (subpath ? "/#{subpath}" : "") + ".#{format}"
    end
  
    # Gets info_for(serial)
    def info_for(serial)
      self.get self.path(serial)
    end
    
    def search(query)
      self.get self.path, {:query => query}
    end  
  end
end