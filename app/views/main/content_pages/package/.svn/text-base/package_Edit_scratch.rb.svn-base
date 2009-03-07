<div id="comp_licenses", class="association_table">
	<table>
		<% @tabset.active_tab.content.computers.each do |c| %>
			<tr class="<%= cycle("even","odd") %>" >
		      	<td>
		      		<%= c.short_name %>
		 		</td>
				<td>
					<%= link_to_remote "X", {  	:url => 	{ 	:action		=> 	:remove_package_from_computer,
																:pkg		=>	@tabset.active_tab.content.id,
																:type		=> 	c.class,
																:comp		=>	c.id}},
												:confirm	=>	("Are you sure you want to remove " + c.short_name + "?")%>
				</td>
			</tr>
		<% end %>
	</table>
</div>
<%= drop_receiving_element('comp_licenses', 
	:accept => 'Computer', 
	:complete => "$('spinner').hide();", 
	:before => "$('spinner').show();", 
	:hoverclass => 'hover', 
	:with => "'comp=' + encodeURIComponent(element.id.split('_').last())", 
	:url => {:action=>:add_license_to_computer, :pkg=>@tabset.active_tab.content})%>
<br/>
<div id="actions", class="association_table">
	<table>
		<% @tabset.active_tab.content.actions.each do |a| %>
	    	<tr class="<%= cycle("even","odd") %>" >
	     		<td>
	      			<%= a.action_type %>
	 			</td>
				<td>
					<%= link_to_remote "X", {  	:url => 	{ 	:action		=> 	:remove_action_from_package,
																:pkg		=>	@tabset.active_tab.content.id,
																:action		=>	a.id}},
												:confirm	=>	("Are you sure you want to remove " + a.action_type + " action for the " 			
																	+ @tabset.active_tab.content.short_name + " package?")%>
				</td>
			</tr>
	    <% end %>
	</table>
	<%= link_to_remote "New...", {  	:url => 	{ 	:action	=>	:new_action_for_package,
														:pkg	=>	@tabset.active_tab.content.id}}%>
</div>