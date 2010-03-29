Feature: Search for objects in the home page

	So that I can find objects I wish to work easily
	As a technician
	I want to be able to search for and open objects in a unified interface
	
	Scenario: Search for a computer
		Given a computer with serial number 81234
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		Then I should see an entry for the computer in the results list
		
		Given a computer with serial number 81235
		When I go to the home page
		And the system updates the index
		And I type the model of the computer into the search box
		And I press "Search"
		Then I should see an entry for the computer in the results list
		
		Given a computer with serial number 81236
		When I go to the home page
		And the system updates the index
		And I type the po_number of the computer into the search box
		And I press "Search"
		Then I should see an entry for the computer in the results list
		
		Given a computer with serial number 81237
		And the computer is in a stage that offers deployment information
		When I go to the home page
		And the system updates the index
		And I type the owner of the computer into the search box
		And I press "Search"
		Then I should see an entry for the computer in the results list
		
		
	
	Scenario: Search for a peripheral
		Given a peripheral with serial number 81238
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the peripheral into the search box
		And I press "Search"
		Then I should see an entry for the peripheral in the results list
		
		Given a peripheral with serial number 81239
		When I go to the home page
		And the system updates the index
		And I type the model of the peripheral into the search box
		And I press "Search"
		Then I should see an entry for the peripheral in the results list 
	
	Scenario: Search for a package
		Given a package with name "Rabbit"
		When I go to the home page
		And the system updates the index
		And I type the manufacturer of the package into the search box
		And I press "Search"
		Then I should see an entry for the package in the results list
		
		Given a package with name "Tickles"
		When I go to the home page
		And the system updates the index
		And I type the name of the package into the search box
		And I press "Search"
		Then I should see an entry for the package in the results list
		
		Given a package with name "Spigot"
		When I go to the home page
		And the system updates the index
		And I type the version of the package into the search box
		And I press "Search"
		Then I should see an entry for the package in the results list
	
	Scenario: Open a computer
		Given a computer with serial number 81240
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I follow the link for the computer
		Then I should have a tab for the computer
	
	Scenario: Open a peripheral
		Given a peripheral with serial number 81241
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the peripheral into the search box
		And I press "Search"
		And I follow the link for the peripheral
		And I wait for 2 seconds
		Then I should have a tab for the peripheral
	
	Scenario: Open a package
		Given a package with name "Rabbit"
		When I go to the home page
		And the system updates the index
		And I type the manufacturer of the package into the search box
		And I press "Search"
		And I follow the link for the package
		And I wait for 2 seconds
		Then I should have a tab for the package
	