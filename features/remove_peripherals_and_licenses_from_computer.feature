Feature: Examine Computers

	So that I can get information about computers that are in inventory
	As a technician
	I want to look up information on computers
	
	Scenario: Removing existing licenses
		Given a computer with serial number 23433
		And the computer is in a stage that offers deployment information
		And several attached licenses
		When I go to the show page for computer 23433
		And I follow "assigned_licenses_closed_link"
		And I click on remove for the first license
		And I wait for 3 seconds
		Then the first license should not be assigned to the computer
	
	Scenario: Remove existing peripherals
		Given a computer with serial number 23434
		And the computer is in a stage that offers deployment information
		And several attached peripherals
		When I go to the show page for computer 23434
		And I follow "installed_peripherals_closed_link"
		And I click on remove for the first peripheral
		And I wait for 3 seconds
		Then the first peripheral should not be assigned to the computer