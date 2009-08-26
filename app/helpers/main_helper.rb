module MainHelper
  def closed_disclosure_area(id, view, title=nil, div=nil, action=nil)
    div ||= view.split('/').last
    title ||= div.split('_').each{ |word| word.capitalize! }.join(" ")
    action ||= "open_" + div
    
    opening = "<div><table><tr>"
    closing = "</tr></table></div>"
    
    image = image_tag(	"/images/disclosure_closed.gif", 
					              :height => "20px",
					              :width => "20px",
					              :style => "border: none")
		url = { 	:action => action, 
					    :id 		=> id,
					    :view   => view }
		update = div
    
    disclosure_arrow = "<td>" + link_to_remote(image, 
        :url => url, 
        :update => update,
        :complete => "$('spinner').hide();", 
		    :before => "$('spinner').show();",) + "</td>"
    div_title = "<td><b>#{title}</b></td>"
    
    return opening + disclosure_arrow + div_title + closing
  end
  def open_disclosure_area(id, view, title=nil, div=nil, action=nil)
    div ||= view.split('/').last
    title ||= div.split('_').each{ |word| word.capitalize! }.join(" ")
    action ||= "close_" + div

    opening = "<div><table><tr>"
    closing = "</tr></table></div>"
    
    image = image_tag(	"/images/disclosure_open.gif", 
					              :height => "20px",
					              :width => "20px",
					              :style => "border: none")
		url = { 	:action => action, 
					    :id 		=> id,
					    :view   => view }
		update = div
    
    disclosure_arrow = "<td>" + link_to_remote(image, :url => url, :update => update) + "</td>"
    div_title = "<td><b>#{title}</b></td>"
    partial = render :partial => view
    
    return opening + disclosure_arrow + div_title + closing + partial
  end
  def service_list(platform, domain, service_type)
    return Array.new() unless @services.key?(platform)
    return Array.new() unless @services[platform].key?(domain)
    return Array.new() unless @services[platform][domain].key?(service_type)
    return @services[platform][domain][service_type]
  end
  
end
