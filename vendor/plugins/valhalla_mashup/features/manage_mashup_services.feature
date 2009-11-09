Feature: Interact with an external HTTP mashup service
  	So as to communicate with external services that manage the resources stored in inventory
  	The application should be able to 
  	Send basic get, post, put and delete queries to an external server
  
	Scenario Outline: Define a mashup service
    	Given an address string <address>
		When I define a new mashup service with it
		Then the host of the mashup service should be <host>
		And the path of the mashup service should be <url>
		And the user of the mashup service should be <username>
		And the password of the mashup service should be <password>
		
		Scenarios: Simple URL
			| address          										| host				| path				| user		| password 	|
			| http://test.com 										| test.com 			| nil 				| nil 		| nil 		|
			| http://pathedtest.com/in/some/folders/ 				| pathedtest.com 	| in/some/folders/	| nil 		| nil 		|
	
		Scenarios: URL with authentication parameters
			| address          										| host				| path				| user		| password 	|
			| http://testuser:password@test.com/ 					| test.com 			| nil 				| testuser	| password 	|
			| http://uSeR:12345@pathedtest.com/in/some/folders/ 	| pathedtest.com 	| in/some/folders/ 	| uSeR 		| 12345 	|	
	
		Scenarios: SSL URLs
			| address          										| host				| path				| user		| password 	|
			| https://test.com 										| test.com 			| nil 				| nil 		| nil 		|
			| https://pathedtest.com/in/some/folders/ 				| pathedtest.com 	| in/some/folders/	| nil 		| nil 		|
			| https://testuser:password@test.com/ 					| test.com 			| nil 				| testuser	| password 	|
			| https://uSeR:12345@pathedtest.com/in/some/folders/ 	| pathedtest.com 	| in/some/folders/ 	| uSeR 		| 12345 	|
	
	
	Scenario Outline: Sending a GET to a mashup service
		Given a mashup service with address <address>
		When I send a GET request to <path> with parameters <parameters>
		Then the request should return a value of 200
		
		Scenarios: Simple URL
			| address          										| path				| parameters 							|
			| http://test.com/ 										| index.html 		| {}		 							|
			| http://test.com/in/some/folders/ 						| test/index.html 	| {} 		 							|
		
		Scenarios: Authenticated access
			| address												| path				| parameters 							|
			| http://testuser:password@test.com/ 					| index.html 		| {}	 								|
			| http://uSeR:12345@pathedtest.com/in/some/folders/ 	| test/index.htm 	| {}									|
		
		Scenarios: Queries
			| address          										| path				| parameters 							|
			| http://uSeR:12345@pathedtest.com/in/some/folders/ 	| test/index.html	| {test1 => pooka, test2 => beansidhe}	|
			| http://test.com/ 										| index.html		| {test4 => brownCow} 					|
			
		
	
