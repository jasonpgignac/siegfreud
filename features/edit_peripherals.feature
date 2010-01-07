Feature: Edit Peripherals

	So that I can keep inventory updated as peripherals are moved, etc
	As a technician
	I want to use the edit page to change the stage, deployment, and location data for a given computer
	
	Scenario: Changing the stage of a peripheral to one that requires deployment information
		Given a peripheral in a stage with [location] information with serial number 00007
		And a stage is available with [deployment] information
		When I go to the edit page for peripheral 00007
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_owner" with "ugignja"
		And I fill in "peripheral_description" with "Sitting under the old oak tree"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a peripheral in a stage with [location] information with serial number 00008
		And a stage is available with [deployment] information
		When I go to the edit page for peripheral 00008
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_owner" with "ugignja"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	Scenario: Changing the stage of a computer to one that requires location information
		Given a peripheral in a stage with [deployment] information with serial number 00009
		And a stage is available with [location] information
		When I go to the edit page for peripheral 00009
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_location" with "Under the Mistletoe"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a peripheral in a stage with [deployment] information with serial number 00010
		And a stage is available with [location] information
		When I go to the edit page for peripheral 00010
		And I select "Stage B" from "peripheral_stage_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	Scenario: Changing the stage of a peripheral to one that requires deployment and location information
		Given a peripheral in a stage with [deployment] information with serial number 00011
		And a stage is available with [location,deployment] information
		When I go to the edit page for peripheral 00011
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_description" with "Used for mu"
		And I fill in "peripheral_owner" with "ugignja"
		And I fill in "peripheral_location" with "Under the Mistletoe"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a peripheral in a stage with [deployment] information with serial number 00012
		And a stage is available with [location,deployment] information
		When I go to the edit page for peripheral 00012
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_owner" with "ugignja"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	Scenario: Changing the deployment information on a peripheral without changing the stage
		Given a peripheral in a stage with [deployment] information with serial number 00013
		When I go to the edit page for peripheral 00013
		And I fill in "peripheral_owner" with "ugghjfg"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
	
	Scenario: Changing the location information on a peripheral without changing the stage
		Given a peripheral in a stage with [location] information with serial number 00014
		When I go to the edit page for peripheral 00014
		And I fill in "peripheral_location" with "In my nose"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
	
	Scenario: Changing from computer to a regular stage
		Given a peripheral in a stage with [computer] information with serial number 00016
		And a stage is available with [location] information
		When I go to the edit page for peripheral 00016
		And I select "Stage B" from "peripheral_stage_id"
		And I fill in "peripheral_location" with "In my nose"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
	
	Scenario: Changing from a regular stage to a compter
		Given a peripheral in a stage with [location] information with serial number 00017
		And a computer in a stage with [deployment] information with serial number 00018
		When I go to the edit page for peripheral 00017
		And I select "Assigned to Computer" from "peripheral_stage_id"
		And I fill in "computer_name" with "Comp-00018"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a peripheral in a stage with [location] information with serial number 00019
		And a computer in a stage with [deployment] information with serial number 00020
		When I go to the edit page for peripheral 00019
		And I select "Assigned to Computer" from "peripheral_stage_id"
		And I wait for 2 seconds
		And I fill in "computer_name" with "Comp-BADNAME"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
		