<p>Mac Address: <%= form.text_field :mac_address %></p>


<p>Licenses:</p>
<div id="comp_licenses", class="association_table">
	<table>
		<% @tabset.active_tab.content.packages.each do |p| %>
	    	<tr class="<%= cycle("even","odd") %>" >
	      		<td>
	      			<%= p.short_name %>
	 			</td>
				<td>
					<%= link_to_remote "X", {  	:url => {:action		=> 	:remove_package_from_computer,
												:pkg		=>	p.id,
												:type		=> 	p.class,
												:comp		=>	@tabset.active_tab.content.id}},
												:confirm	=>	("Are you sure you want to remove " + p.short_name + "?")%>
				</td>
			</tr>
		<% end %>
	</table>
</div>
<%= drop_receiving_element('comp_user', 
	:accept => 'User', 
	:complete => "$('spinner').hide();", 
	:before => "$('spinner').show();", 
	:hoverclass => 'hover', 
	:with => "'user=' + encodeURIComponent(element.id.split('_').last())", 
	:url => {:action=>:add_user_to_computer, :id=>@tabset.active_tab.content})%>
<%= drop_receiving_element('comp_licenses', 
	:accept => 'Package', 
	:complete => "$('spinner').hide();", 
	:before => "$('spinner').show();", 
	:hoverclass => 'hover', 
	:with => "'pkg=' + encodeURIComponent(element.id.split('_').last())", 
	:url => {:action=>:add_license_to_computer, :comp=>@tabset.active_tab.content})%>
