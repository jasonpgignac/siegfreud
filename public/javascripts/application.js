// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function assigned_licenses(request) { 
	licenses = request.responseText.evalJSON();
	$('assigned_licenses').innerHTML = ' ';
	if(licenses.length > 0) {
		insert = '<ul>' 
		licenses.each(
			function(license, index) {
				insert = insert + 
					'<li>' + license.license.package.manufacturer + 
					' ' + license.license.package.name +
					' ' + license.license.package.version + 
					' (' + license.license.license_key + ')</li>';
			}
		);
		insert = insert + '</ul>';
	} else {
		insert = "No Licenses Assigned"
	}
	new Insertion.Bottom('assigned_licenses', insert); 
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

function software_management(request) {
	info_sets = request.responseText.evalJSON();
	var rows = new Array();
	for(info_set_name in info_sets) {
		info_set = info_sets[info_set_name];
		info_set.each(
			function(advert, index) {
				rows.push([info_set_name,advert.name]);
			}
		)
	}
	
	code = "<table><tr><th>Name</th><th>Server</th></tr>";
	rows.each( function(row, index) {
		code = code + "<tr><td>" + row[0] + "</td><td>" + row[1] + "</td></tr>"
	})
	code = code + "</table>"
	new Insertion.Bottom('software_management', code)
}

function computer_information(request) {
	info_sets = request.responseText.evalJSON();
	var fields = new Array();
	for(info_set_name in info_sets) {
		
		for(name in info_sets[info_set_name]) {
			fields.push(name);
		}
	}
	fields = fields.uniq();
	code = "<table><tr><th>Fields</th>";
	for (info_set_name in info_sets) {
		code = code + "<th>" + info_set_name + "</th>"
	}
	code = code + "</tr>"
	fields.each(
		function(field, index) {
			code = code + "<tr><td>" + field + "</td>"
			for (info_set_name in info_sets) {
				code = code + "<td>" + info_sets[info_set_name][field] + "</td>"
			}
			code = code + "</tr>"
		}
	)
	code = code + "</table>"
	new Insertion.Bottom('computer_information', code)
}