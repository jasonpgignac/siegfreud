Feature: Edit Computers

	So that I can keep inventory updated as computers are moved, etc
	As a technician
	I want to use the edit page to change the stage, deployment, and location data for a given computer
	
	Scenario: Changing the stage of a computer to one that requires deployment information
		Given a computer in a stage with [location] information with serial number B000
		And a stage is available with [deployment] information
		When I go to the edit page for computer B000
		And I select "Stage B" from "computer_stage_id"
		And I fill in "computer_owner" with "ugignja"
		And I fill in "computer_name" with "X-B000"
		And I select "Primary" from "computer_system_role"
		And I select "test.com" from "computer_domain_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a computer in a stage with [location] information with serial number B001
		And a stage is available with [deployment] information
		When I go to the edit page for computer B001
		And I select "Stage B" from "computer_stage_id"
		And I fill in "computer_owner" with "ugignja"
		And I select "Primary" from "computer_system_role"
		And I select "test.com" from "computer_domain_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	Scenario: Changing the stage of a computer to one that requires location information
		Given a computer in a stage with [deployment] information with serial number B002
		And a stage is available with [location] information
		When I go to the edit page for computer B002
		And I select "Stage B" from "computer_stage_id"
		And I fill in "computer_location" with "Under the Mistletoe"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a computer in a stage with [deployment] information with serial number B003
		And a stage is available with [location] information
		When I go to the edit page for computer B003
		And I select "Stage B" from "computer_stage_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	Scenario: Changing the stage of a computer to one that requires deployment and location information
		Given a computer in a stage with [deployment] information with serial number B004
		And a stage is available with [location,deployment] information
		When I go to the edit page for computer B004
		And I select "Stage B" from "computer_stage_id"
		And I fill in "computer_location" with "Under the Mistletoe"
		And I fill in "computer_owner" with "ugignja"
		And I fill in "computer_name" with "X-B000"
		And I select "Primary" from "computer_system_role"
		And I select "test.com" from "computer_domain_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
		
		Given a computer in a stage with [deployment] information with serial number B003
		And a stage is available with [location,deployment] information
		When I go to the edit page for computer B003
		And I select "Stage B" from "computer_stage_id"
		And I fill in "computer_owner" with "ugignja"
		And I fill in "computer_name" with "X-B000"
		And I select "Primary" from "computer_system_role"
		And I select "test.com" from "computer_domain_id"
		And I press "Save"
		And I wait for 5 seconds
		Then I should see "error"
	
	
	Scenario: Changing the deployment information on a computer without changing the stage
		Given a computer in a stage with [deployment] information with serial number B005
		When I go to the edit page for computer B005
		And I fill in "computer_owner" with "ugignja"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
	
	Scenario: Changing the location information on a computer without changing the stage
		Given a computer in a stage with [location] information with serial number B006
		When I go to the edit page for computer B006
		And I fill in "computer_location" with "In my nose"
		And I press "Save"
		And I wait for 5 seconds
		Then I should not see "error"
	

	
	