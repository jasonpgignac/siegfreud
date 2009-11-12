module MainHelper
  def closed_computer_service_disclosure_area(service, computer)
    closed_disclosure_area( service_div_name(service),
		 		                    computer_path(	@computer.serial_number, 
								              :format 		      => :json,
								              :service_class 	  => service.class.to_s,
								              :service_name	    => service.name,
								              :service_address  => service.url),
								            service.class.to_s.demodulize.tableize)
  end
  def service_div_name(service)
    "#{service.name.sub(" ","_")}_" + service.class.to_s.demodulize.tableize
  end
  def closed_disclosure_area(div, url, script=nil)
    "<div>
      <table>
        <tr>
          <td id='#{div.to_s + "_open"}'style='display: none'>" + open_arrow(div) + "</td>
          <td id='#{div.to_s + "_closed"}'>" + closed_arrow(div, url, script) + " </td>
          <td><b>#{title(div)}</b></td>
        </tr>
      </table>
    </div>"
  end
  def open_disclosure_area(id, url)
    opening = "<div><table><tr>"
    closing = "</tr></table></div>"
    
		disclosure_arrow = "<td>" + link_to_remote(image, url,
        :update => div,
        :complete => "$('spinner').hide();", 
		    :before => "$('spinner').show();") + "</td>"
    div_title = "<td><b>#{title}</b></td>"
    partial = render :partial => view
    
    return opening + disclosure_arrow + div_title + closing + partial
  end
  def open_arrow(div)
    image = image_tag(	"/images/disclosure_open.gif", 
					              :height => "20px",
					              :width => "20px",
					              :style => "border: none;")
		link_to_function image, "$('#{div}').hide();$('#{div.to_s + "_open"}').hide();$('#{div.to_s + "_closed"}').show();"
  end
  def closed_arrow(div, url, script=nil)
    script ||= div
    img = image_tag(	"/images/disclosure_closed.gif", 
					              :height => "20px",
					              :width => "20px",
					              :style => "border: none")
		link_to_remote( img,
                    :url => url,
                    :method => :get,
                    :complete => "#{script}(request);$('spinner').hide();$('#{div}').show();$('#{div.to_s + "_closed"}').hide();$('#{div.to_s + "_open"}').show();", 
                    :before => "$('spinner').show();")
  end
  def title(div)
    div.to_s.split("_").collect{ |s| s.capitalize }.join(" ")
  end
  def service_list(platform, domain, service_type)
    return Array.new() unless @services.key?(platform)
    return Array.new() unless @services[platform].key?(domain)
    return Array.new() unless @services[platform][domain].key?(service_type)
    return @services[platform][domain][service_type]
  end
  
end
