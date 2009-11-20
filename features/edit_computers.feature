Feature: Edit Computers

	So that I can keep inventory updated as computers are moved, etc
	As a technician
	I want to use the edit page to change the stage, deployment, and location data for a given computer
	
	Scenario: Changing the stage of a computer to one that requires deployment information
		Given a computer in a stage with [location] information with serial number B000
		And a stage is available with [deployment] information
		When I go to the edit page for computer B000
		And I fill in the following:
			| Stage	ID		| 2 		|
			| Owner			| ugignja 	|
			| Name			| X-B000	|
			| System Role	| Primary	|
			| Domain ID		| 1			|
		And I press "Save"
		Then I should be on computer_path("B000")
		
		Given a computer in a stage with [location] information with serial number B001
		And a stage is available with [deployment] information
		When I go to the edit page for computer B001
		And I fill in the following:
			| Stage	ID		| 2 		|
			| Owner			| ugignja 	|
			| Name			| X-B000	|
			| Domain ID		| 1			|
		And I press "Save"
		Then I should be on edit_computer_path("B001")
		And I should see "This stage requires that you define the System Role field"
	
	Scenario: Changing the stage of a computer to one that requires location information
		Given a computer in a stage with [deployment] information with serial number B002
		And a stage is available with [location] information
		When I go to the edit page for computer B002
		And I fill in the following:
			| Stage	ID		| 2 					|
			| Location		| Under the Mistletoe 	|
		And I press "Save"
		Then I should be on computer_path("B002")
		
		Given a computer in a stage with [deployment] information with serial number B003
		And a stage is available with [location] information
		When I go to the edit page for computer B003
		And I fill in the following:
			| Stage	ID		| 2						|
		And I press "Save"
		Then I should be on edit_computer_path("B003")
		And I should see "This stage requires that you define the Location field"
	
	Scenario: Changing the stage of a computer to one that requires deployment and location information
	
	Scenario: Changing the deployment information on a computer without changing the stage
	
	Scenario: Changing the location information on a computer without changing the stage
	

	
	