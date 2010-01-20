module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the login page/
      login_path
    when /^the show page for computer (.*)$/ 
      computer_path($1)
    when /^the show page for peripheral (.*)$/ 
      peripheral_path(Peripheral.find_by_serial_number($1).id)
    when /^the edit page for computer (.*)$/ 
      edit_computer_path($1)  
    when /^the edit page for peripheral (.*)$/ 
      edit_peripheral_path(Peripheral.find_by_serial_number($1).id) 
    when /^the edit page for purchase order "(.*)"$/
      edit_purchase_order_path($1) 
    when /^the new page for purchase orders$/
      new_purchase_order_path
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
