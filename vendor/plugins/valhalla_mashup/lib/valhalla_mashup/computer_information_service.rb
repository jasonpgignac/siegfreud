module ValhallaMashup
  class ComputerInformationService < MashupService
    
    def initialize(*args)
      super
      raise(RuntimeError,"This class requires the following field to be defined: computer_key_field") unless @computer_key_field
    end
    
    def path(subpath = nil, format = "json")
      "computers" + (subpath ? "/#{subpath}" : "") + ".#{format}"
    end
  
    # Gets info_for(serial)
    def info_for(computer)
      self.get self.path(eval("computer.#{@computer_key_field}"))
    end
    
    def search(query)
      self.get self.path, {:query => query}
    end  
  end
end