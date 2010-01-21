module ValhallaMashup
  class ComputerInformationService < MashupService
    
    def initialize(*args)
      super
      raise(RuntimeError,"This class requires the following field to be defined: computer_key_field") unless @computer_key_field
    end
    
    def path(subpath = nil, format = "json")
      "computers" + (subpath ? "/#{subpath}" : "") + ".#{format}"
    end

    def info_for(item)
      if item.is_a?(Computer)
        self.get self.path(eval("item.#{@computer_key_field}"))
      elsif item.is_a?(SiteMap)
        self.get "computer_groups/#{item.remote_site_id}/members.json"
      else 
        raise RuntimeError, "No mapping for info for items of type #{item.class.to_s}"
      end
    end
    
    def search(query)
      self.get self.path, {:query => query}
    end  
  end
end