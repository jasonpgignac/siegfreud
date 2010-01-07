Feature: Modify License assignments

	So that I can track which license are assigned to a given computer
	As a technician
	I want to add and remove licenses from a given system
	
	Scenario: Adding a license
		Given a computer with serial number 23705
		And the computer is in a stage that offers deployment information
		And a package with name Picklestar
		And a license of package "Picklestar" with serial number 23706
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I follow the link for the computer
		And I wait for 2 seconds
		And I follow "assigned_licenses_closed_link"
		And I wait for 60 seconds
		And I type the name of the package into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I drag the package onto the computer
		And I wait for 2 seconds
		And I press "Assign License"
		Then I should see the license listed
		And the license record should be assigned to the computer

		Given a computer with serial number 23706
		And the computer is in a stage that offers deployment information
		And a package with name "Picklestar"
		And a license of package "Picklestar" with serial number 23706
		And the license is in a different division
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I follow the link for the computer
		And I wait for 2 seconds
		And I type the name of the package into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I drag the package onto the computer
		And I wait for 2 seconds
		Then I should see "There are no licenses of this package in the computer's division"
	
	Scenario: Removing a license
		Given a computer with serial number 76245
		And the computer is in a stage that offers deployment information
		And several attached licenses
		When I go to the home page
		And the system updates the index
		And I type the serial_number of the computer into the search box
		And I press "Search"
		And I wait for 2 seconds
		And I follow the link for the computer
		And I wait for 2 seconds
		And I follow "assigned_licenses_closed_link"
		And I delete the first license
		Then I should not see the license listed
		And the license record should not be assigned to the computer
	
