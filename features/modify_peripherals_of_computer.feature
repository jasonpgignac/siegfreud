Feature: Modify Peripheral assignments

	So that I can track which peripherals are assigned to a given computer
	As a technician
	I want to add and remove peripherals from a given system
	
	Scenario: Adding a peripheral
		Given a computer with serial number 23701
		And the computer is in a stage that offers deployment information
		And a peripheral with serial number 23702
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I follow the link for the computer
		And I follow "installed_peripherals_closed_link"
		And I type the serial_number of the peripheral into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I drag the peripheral onto the computer
		And I wait for 2 seconds
		Then I should see the peripheral listed
		And the peripheral record should be assigned to the computer
		
		Given a computer with serial number 23703
		And the computer is in a stage that offers deployment information
		And a peripheral with serial number 23704
		And the peripheral is in a different division
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I follow the link for the computer
		And I wait for 2 seconds
		And I type the serial_number of the peripheral into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I drag the peripheral onto the computer
		And I wait for 2 seconds
		Then I should see "The peripheral and computer are not in the same division"
	
	Scenario: Removing a peripheral
		Given a computer with serial number 76245
		And the computer is in a stage that offers deployment information
		And several attached peripherals
		And there is a storage stage
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I follow the link for the computer
		And I wait for 2 seconds
		And I follow "installed_peripherals_closed_link"
		And I delete the first peripheral
		And I fill in "peripheral_location" with "The Underworld"
		And I press "Move"
		And I wait for 30 seconds
		Then I should not see the peripheral listed
		And the peripheral record should not be assigned to the computer
	
	
	