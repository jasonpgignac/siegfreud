# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def options_from_array_of_hashes(array, value, name)
    options = ""
    array.each do |hash|
      options += "<option value=\"#{hash[value]}\">#{hash[name]}</option>\n"
    end
    return options
  end
end
