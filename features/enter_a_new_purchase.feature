Feature: Enter a new purchase

	So that I can purchase new inventory
	As a technician
	I want to add new machines, licenses, bundles, and peripherals to inventory
	
	Scenario: Starting a new PO
		Given a division
		When I go to the home page
		And I press "Add Inventory"
		And I fill in "purchase_order_po_number" with "01151980"
		And I press "Create"
		Then I should see "New"
		And I should see "error"
		
		When I fill in "purchase_order_po_number" with "01151980"
		And I select "Division X (100,101,102)" from "purchase_order_division_id"
		And I press "Create"
		And I wait for 3 seconds
		Then I should be on the edit page for purchase order "01151980"
	
		Given there is a storage stage
		And there is a site named "Poughkeepsie"
		When I press "New Computer"
		And I fill in "computer_serial_number" with "EP00001"
		And I fill in "computer_model" with "Dell Huchinpao 780"
		And I select "Win32" from "computer_system_class"
		And I select "Storage" from "computer_stage_id"
		And I select "Poughkeepsie" from "computer_site_id"
		And I wait for 2 seconds
		And I fill in "computer_location" with "Inside the Hippo"
		And I press "Create"
		And I wait for 5 seconds
		Then I should see "created"
		And I should see "EP00001"
		And I should see "Dell Huchinpao 780"
		And there should be record for a computer with serial number "EP00001"
		
		When I press "New Peripheral"
		And I fill in "peripheral_serial_number" with "EP00002"
		And I fill in "peripheral_model" with "Monitor Lizard"
		And I select "Storage" from "peripheral_stage_id"
		And I wait for 2 seconds
		And I fill in "peripheral_location" with "Cage"
		And I press "Create"
		Then I should see "created"
		And I should see "EP00002"
		And I should see "Monitor Lizard"
		And there should be a record for a peripheral with serial number "EP00002"