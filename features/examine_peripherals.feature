Feature: Examine Peripherals

	So that I can get information about peripherals that are in inventory
	As a technician
	I want to look up information on peripherals
	
	Scenario: Look up basic inventory data on a peripheral
		Given a peripheral with serial number 000001
		When I go to the show page for peripheral 000001
		Then I should see the basic inventory fields for the peripheral
		
		Given a peripheral with serial number 000002
		And the peripheral is in a stage that offers location information
		When I go to the show page for peripheral 000002
		Then I should see the location fields for the peripheral
		
		Given a peripheral with serial number 000003
		And the peripheral is in a stage that offers deployment information
		When I go to the show page for peripheral 000003
		Then I should see the deployment fields for the peripheral
		
		Given a peripheral with serial number 000004
		And the peripheral is in a stage that offers location information
		And the peripheral is in a stage that offers deployment information
		When I go to the show page for peripheral 000004
		Then I should see the deployment fields for the peripheral
		And I should see the location fields for the peripheral
		
		Given a computer with serial number 000006
		And the computer is in a stage that offers deployment information
		And a peripheral with serial number 000005
		And the peripheral is installed on the computer
		When I go to the show page for peripheral 000005
		Then I should not see the deployment fields for the peripheral
		And I should not see the stage field for the peripheral
		And I should not see the location fields for the peripheral
		And I should see the computer information fields for the peripheral
	
