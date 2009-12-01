Feature: Examine Computers

	So that I can get information about computers that are in inventory
	As a technician
	I want to look up information on computers
	
	Scenario: Look up basic inventory data on a computer
		Given a computer with serial number 1234567
		When I go to the show page for computer 1234567
		Then I should see the basic inventory fields
		
		Given a computer with serial number 1234568
		And a stage that offers location information
		When I go to the show page for computer 1234568
		Then I should see the location fields
		
		Given a computer with serial number 1234569
		And a stage that offers deployment information
		When I go to the show page for computer 1234569
		Then I should see the deployment fields
		
		Given a computer with serial number 1234560
		And a stage that offers location information
		And a stage that offers deployment information
		When I go to the show page for computer 1234560
		Then I should see the deployment fields
		And I should see the location fields
	
	Scenario: Look up Peripheral and License information
		Given a computer with serial number 324394
		And a stage that offers deployment information
		When I go to the show page for computer 324394
		Then I should see a button for peripherals
		And I should see a button for licenses
		
		Given a computer with serial number 324234
		And a stage that does not offer deployment information
		When I go to the show page for computer 324234
		Then I should not see a button for peripherals
		And I should not see a button for licenses
		
		Given a computer with serial number 76457
		And a stage that offers deployment information
		And several attached licenses
		When I go to the show page for computer 76457
		And I follow "assigned_licenses_closed_link"
		Then I should see each license
		
		Given a computer with serial number 76245
		And a stage that offers deployment information
		And several attached peripherals
		When I go to the show page for computer 76245 
		And I follow "installed_peripherals_closed_link"
		Then I should see each peripheral
	
	Scenario: Look up machine from external computer information services
		Given a computer with serial number 23423
		And a stage that offers deployment information
		And computer information services in the same domain and platform
		When I go to the show page for computer 23423
		Then I should see "Computer Information"
		
		Given a computer with serial number 23425
		And a stage that does not offer deployment information
		And computer information services in the same domain and platform
		When I go to the show page for computer 23425
		Then I should not see "Computer Information"
		
		Given a computer with serial number 23426
		And a stage that offers deployment information
		And computer information services in the same domain but a different platform
		When I go to the show page for computer 23426
		Then I should not see "Computer Information"
		
		Given a computer with serial number 23427
		And a stage that offers deployment information
		And computer information services in the same platform but a different domain
		When I go to the show page for computer 23427
		Then I should not see "Computer Information"
		
		Given a computer with serial number 23428
		And a stage that offers deployment information
		And computer information services in the same domain and platform
		When I go to the show page for computer 23428
		And I click the button to retrieve remote computer information
		Then I should see the computer information from each service
	
	Scenario: Look up machine from external software management services

		Given a computer with serial number 23429
		And a stage that offers deployment information
		And software management services in the same domain and platform
		When I go to the show page for computer 23429
		Then I should see "Software Management"

		Given a computer with serial number 23430
		And a stage that offers deployment information
		And software management services in the same domain but a different platform
		When I go to the show page for computer 23430
		Then I should not see "Software Management"

		Given a computer with serial number 23431
		And a stage that offers deployment information
		And software management services in the same platform but a different domain
		When I go to the show page for computer 23431
		Then I should not see "Software Management"

		Given a computer with serial number 23432
		And a stage that offers deployment information
		And software management services in the same domain and platform
		When I go to the show page for computer 23432
		And I click the button to retrieve remote software management information
		Then I should see the software management information from each service
	


		