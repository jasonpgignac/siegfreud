Before do
  u = User.find_by_username("test_tech") || User.create(
      :username => "test_tech",
      :email    => "test_tech@nowhere.com",
      :password => "Test",
      :password_confirmation => "Test",
      :admin    => true
  )
  u.admin = true
  u.save
  
  visit path_to('the login page')
  fill_in(:username, :with => "test_tech")
  fill_in(:password, :with => 'Test')
  click_button('Create')
  
  sleep(3)
end