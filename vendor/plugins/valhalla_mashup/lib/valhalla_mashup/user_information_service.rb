module ValhallaMashup
class UserInformationService < MashupService
  def path(subpath = nil, format = "json")
    "users" + (subpath ? "/#{subpath}" : "") + ".#{format}"
  end
  
  def info_for(username)
    computer_record = self.get(path(username))
  end

end
end