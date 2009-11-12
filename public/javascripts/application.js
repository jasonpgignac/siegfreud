// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function assigned_licenses(request) { 
	licenses = request.responseText.evalJSON();
	$('assigned_licenses').innerHTML = ' '; 
	new Insertion.Bottom('assigned_licenses'), '<ul>'
	licenses.each(
		function(license, index) {
			new Insertion.Bottom('assigned_licenses', 
				'<li>' + license.license.package.manufacturer + 
				' ' + license.license.package.name +
				' ' + license.license.package.version + 
				' (' + license.license.license_key + ')</li>');
		}
	); 
	new Insertion.Bottom('assigned_licenses'), '</ul>';
}

function installed_peripherals(request) { 
	peripherals = request.responseText.evalJSON();
	$('installed_peripherals').innerHTML = ' '; 
	new Insertion.Bottom('installed_peripherals'), '<ul>'
	peripherals.each(
		function(peripheral, index) {
			new Insertion.Bottom('installed_peripherals', 
				'<li>' + peripheral.peripheral.model + 
				' (' + peripheral.peripheral.serial_number + ')</li>');
		}
	);
	new Insertion.Bottom('installed_peripherals'), '</ul>'; 
}

function installed_peripherals(request) { 
	peripherals = request.responseText.evalJSON();
	$('installed_peripherals').innerHTML = ' '; 
	new Insertion.Bottom('installed_peripherals'), '<ul>'
	peripherals.each(
		function(peripheral, index) {
			new Insertion.Bottom('installed_peripherals', 
				'<li>' + peripheral.peripheral.model + 
				' (' + peripheral.peripheral.serial_number + ')</li>');
		}
	);
	new Insertion.Bottom('installed_peripherals'), '</ul>'; 
}

function computer_information_services(request) {
}