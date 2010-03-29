class MainController < ApplicationController
  # Display response routines
  def index
    get_tabset;
    @sidebar_buttons = get_sidebar_buttons;
  end
  def search
    session[:search_string] = params[:query]
    get_tabset;
    #@sidebar_buttons = get_sidebar_buttons;
    @sidebar_items = perform_search(session[:search_string], @sidebar_buttons) 
    update_page do |page|
      page.redraw_item_list
    end
  end
  def open_content
    content_type = (params[:type]).camelize.constantize;
    content = (params[:id]) ? content_type.find(params[:id]) : content_type.new();
    get_tabset
    @tabset.open_and_activate(content);
    get_active_content
    update_page do |page|
      page.redraw_tabset;
    end
  end
  def select_tab
    get_tabset;
    @tabset.active_tab=(Tab.find(params[:id]));
    @tabset.save;
    update_page do |page|
      page.redraw_tabset;
    end
  end
  def close_tab
    tab = Tab.find(params[:id]);
    tab.delete;
    get_tabset;
    update_page do |page|
      page.redraw_tabset
    end
  end
  
  # Main Inventory Actions
  # --Manage Licenses
  # --Manage Computer
  def remove_licensed_package
    lic = License.find_by_computer_id(params[:computer_id], :conditions => { :package_id => params[:package_id] })
    lic.remove_from_computer
    get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  
  def method_missing(symbol, *args)
    if symbol.to_s.include?("__")
      function_split = symbol.to_s.split("__")
      function = function_split[0]
      param = function_split[1]
      eval("#{function}(\"#{param}\")")
    end
  end
  
  private

  def service_list(platform, domain, service_type)
    return Array.new() unless @services.key?(platform)
    return Array.new() unless @services[platform].key?(domain)
    return Array.new() unless @services[platform][domain].key?(service_type)
    return @services[platform][domain][service_type]
  end
  # redraw routines
  def update_page
    render :update do |page|
      def page.update_new_license_licensing
        page.replace_html 'new_license_licensing', :partial => 'new_license_licensing'
      end
      def page.switch_to_package_search_results_in_redbox
        page.replace_html 'licensing_redbox_form', :partial => 'new_license_confirm_form'
      end
      def page.redraw_new_computers
        page.replace_html 'new_computers', :partial => 'computers_in_po'
      end
      def page.redraw_new_peripherals
        page.replace_html 'new_peripherals', :partial => 'peripherals_in_po'
      end
      def page.redraw_new_licenses
        page.replace_html 'new_licenses', :partial => 'licenses_in_po'
      end
      def page.redraw_tabset
        page.replace_html 'contentwrapper', :partial => 'content_pane'  
      end
      def page.redraw_active_tab
        page.replace_html 'current_tab', :partial => 'current_tab'
      end
      def page.redraw_item_list
        page.replace_html 'content_list', :partial => 'item_list'
      end
      def page.set_redbox(redbox_partial)
        page << "RedBox.showInline('hidden_content_alert')"
        page.replace_html "hidden_content_alert", :partial => redbox_partial
      end
      def page.close_redbox
        page << "RedBox.close()"
      end
      def page.set_focus(id)
        page << "var firstElement = Form.findFirstElement(document.forms[0]);"
        page << "if(firstElement != null)"
        page << "firstElement.activate();"
      end
      def page.hide_spinner
        page << "$('spinner').hide();"
      end
      
      yield(page)
    end
  end
  
  # Session Variable Management
  def perform_search (search_field, sidebar_buttons)
    return Computer.search(search_field) + Peripheral.search(search_field) + Package.search(search_field) if search_field
    return Array.new
  end
  def get_active_content
    if @tabset.active_tab?
      ivarsym = "@#{@tabset.active_tab.content.class.to_s.downcase}".to_sym
      self.instance_variable_set(ivarsym, @tabset.active_tab.content)
    end
  end
  def get_tabset
    begin
      @tabset = Tabset.find(session[:tabset_id])
    rescue ActiveRecord::RecordNotFound
      @tabset = nil
    end if (session[:tabset_id])
    @tabset ||= Tabset.create
    session[:tabset_id] = @tabset.id;
    get_active_content
  end
  def get_sidebar_buttons
  	if (session[:sidebar_buttons])
  		return session[:sidebar_buttons]
  	else
  		return session[:sidebar_buttons] = Hash["Packages"		=>	true, 
  												                    "Computers"		=>	true,
  												                    "Users"			=>	true,
  												                    "Departments"	=>	false];
  	end
  end
  def service(package_map)
    this_service = nil
    @services.each do |platform, domains|
      domains.each do |domain, service_types|
	service_types["SoftwareManagement"].each do |service|
	  this_service = service if service.name == package_map.service_name
	end
      end
    end
    return this_service
  end
  def install_to_computer(computer, package_map)
    service(package_map).push_task_to_computer(package_map.remote_package_id, package_map.default_install_task, computer.serial_number)
  end
end
