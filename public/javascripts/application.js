// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function assigned_licenses(request) { 
	licenses = request.responseText.evalJSON();
	$('assigned_licenses').innerHTML = ' ';
	insert = '<ul id="assigned_license_list">'; 
	licenses.each(
		function(license, index) {
			insert = insert + output_license_in_list(license);
		}
	);
	insert = insert + '</ul>';
	new Insertion.Bottom('assigned_licenses', insert); 
}
function installed_peripherals(request) { 
	peripherals = request.responseText.evalJSON();
	list = "";
	peripherals.each(
		function(peripheral, index) {
			list = list + output_peripheral_in_list(peripheral);
		}
	);
	
	
	$('installed_peripherals').innerHTML = ' ';
	list = '<ul id="installed_peripherals_list">' + list + '</ul>';
	new Insertion.Bottom('installed_peripherals', list);
}
function output_peripheral_in_list(peripheral) {
	url = "peripherals/" + peripheral.peripheral.id + ".json"
	return '<li  id=\'installed_peripheral_' + peripheral.peripheral.id + '\'>' + 
	peripheral.peripheral.model + ':' + peripheral.peripheral.serial_number + " " + 
	'<a href="#" id= "remove_peripheral_' + peripheral.peripheral.id + '" onclick="select_new_home_for_peripheral(' + peripheral.peripheral.id + ')">X</a></li>';
}
function output_license_in_list(license) {
	url = "licenses/" + license.license.id + ".json"
	return '<li id=\'assigned_license_' + license.license.id + '\'>' + license.license.package.manufacturer + 
	' ' + license.license.package.name +
	' ' + license.license.package.version + 
	' (' + license.license.license_key + ') ' +
	'<a href="#" id= "remove_license_' + license.license.id + '" onclick="new Ajax.Request (\'' + url + '\', { method: \'put\', asynchronous:true, evalScripts:true, parameters: \'license[computer_id]=\', onComplete: function(request) { if(request.status == 200) {RedBox.showInline(\'hidden_content_alert\');$(\'redbox_content\').innerHTML = \' \';new Insertion.Bottom(\'redbox_content\', \'License removed\');$(\'assigned_license_' + license.license.id + '\').remove()} else {RedBox.showInline(\'hidden_content_alert\');$(\'redbox_content\').innerHTML = \' \';errors = request.responseText.evalJSON();errortext = \' \';errors.each(function(error, index) {errortext = errortext + error[1] + \'<br />\'});new Insertion.Bottom(\'redbox_content\', errortext)}}});return false;">X</a></li>'
					
}
function add_peripheral(request) {
	if(request.status == 200) {
		if(document.getElementById('installed_peripherals_list') != null) {
			peripheral = request.responseText.evalJSON();
			periph_listing = output_peripheral_in_list(peripheral);
			new Insertion.Bottom('installed_peripherals_list', periph_listing)
		}
		RedBox.showInline('hidden_content_alert')
		$('redbox_content').innerHTML = ' ';
		new Insertion.Bottom('redbox_content', "Peripheral added")
	} else {
		RedBox.showInline('hidden_content_alert')
		$('redbox_content').innerHTML = ' ';
		errors = request.responseText.evalJSON();
		errortext = " "
		errors.each(
			function(error, index) {
				errortext = errortext + error[1] + "<br />"
			}
		)
		new Insertion.Bottom('redbox_content', errortext)
	}
}
function select_license(request, computer_id) {
	// test if list is empty
	licenses = request.responseText.evalJSON();
	if(isEmpty(licenses)) {
		RedBox.showInline('hidden_content_alert')
		$('redbox_content').innerHTML = ' ';
		errortext = "There are no licenses of this package in the computer's division"
		new Insertion.Bottom('redbox_content', errortext)
		return false;
	}
	buttons = "<form onsubmit='assign_license(this);return false;' name='licensetoassign'>";
	buttons =  buttons + "<input type='hidden' name='license[computer_id]' value='" + computer_id + "'>";
	buttons = buttons + "<input type='radio' name='url' value='/licenses/" + 
				licenses[0].license.id + ".json' checked/>First Available License<br />";
	licenses.each(
		function(license, index) {
			buttons = buttons + "<input type='radio' name='url' value='/licenses/" + 
						license.license.id + ".json' />License " + 
						license.license.license_key + ", PO" + license.license.po_number + "<br />";
		}
	)
	buttons = buttons + "<input type='submit' value='Assign License' /></form>"
	RedBox.showInline('hidden_content_alert')
	$('redbox_content').innerHTML = ' ';
	new Insertion.Bottom('redbox_content', buttons)
}
function assign_license(form) {
	url=" ";
	for(var i = 0; i < form.url.length; i++) {
		x = form.url[i]
		if(x.checked) {
			url = x.value;
		}
	}
	
	new Ajax.Request( url, 
		{
			method:'put',
			asynchronous:true, 
			evalScripts:true,
			parameters: Form.serialize(form),
			onComplete:
				function(request)
				{
					if(request.status == 200) {
						if(document.getElementById('assigned_license_list') != null) {
							license = request.responseText.evalJSON();
							lic_listing = output_license_in_list(license);
							new Insertion.Bottom('assigned_license_list', lic_listing)
						}
						RedBox.showInline('hidden_content_alert')
						$('redbox_content').innerHTML = ' ';
						new Insertion.Bottom('redbox_content', "License added")
					} else {
						RedBox.showInline('hidden_content_alert')
						$('redbox_content').innerHTML = ' ';
						errors = request.responseText.evalJSON();
						errortext = " "
						errors.each(
							function(error, index) {
								errortext = errortext + error[1] + "<br />"
							}
						)
						new Insertion.Bottom('redbox_content', errortext)
					}
				},
		}
	);
}
function remove_peripheral(form, id) {
	url = "peripherals/" + id + ".json";
	new Ajax.Request (url, {
		method: 'put',
		asynchronous: true,
		evalScripts: true,
		parameters: Form.serialize(form),
		onComplete: function(request) {
			if(request.status == 200) {
				$('installed_peripheral_' + id).remove();
				RedBox.showInline('hidden_content_alert');
				$('redbox_content').innerHTML = ' ';
				new Insertion.Bottom('redbox_content', "Peripheral Removed")
			} else {
				RedBox.showInline('hidden_content_alert')
				$('redbox_content').innerHTML = ' ';
				errors = request.responseText.evalJSON();
				errortext = " "
				errors.each(
					function(error, index) {
						errortext = errortext + error[1] + "<br />"
					}
				)
				new Insertion.Bottom('redbox_content', errortext)
			}
		}
	})
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
function select_new_home_for_peripheral(id) {
	RedBox.showInline('hidden_content_alert');
	$('redbox_content').innerHTML = ' ';
	new Insertion.Bottom('redbox_content', peripheralLocationShortForm(id));
	return false;
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

function isEmpty(object) {
	empty = true
	object.each ( function(x, index) {
		empty = false; 
	})
	return empty;
}

function peripheralLocationShortForm(id) {
	return "Moving peripheral to storage, select a location:<br />" +
	'<form onsubmit="remove_peripheral(this, ' + id + ');return false;">' +
	'	<div style="margin:0;padding:0;display:inline">' + 
	'		<input id="peripheral_computer_id" name="peripheral[computer_id]" type="hidden" value=" " />' +
	'		<input id="peripheral_stage_id" name="peripheral[stage_id]" type="hidden" value="first" />' +
	'	</div>' +
	'	<b>Location:</b>' + 
	'	<input id="peripheral_location" name="peripheral[location]" size="30" type="text" value="Cage" /> <br />' + 
	'	<input id="peripheral_submit" name="commit" type="submit" value="Move" />' + 
	'</form>'
}
