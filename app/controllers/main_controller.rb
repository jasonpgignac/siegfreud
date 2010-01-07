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
  
  # Currently inactive objects - non-inventory
  def add_package_to_group
    groupToAddTo = SmsComputerGroup.find_by_remote_id(params[:computer_group_id])
    packageToAdd = SmsPackage.find_by_remote_id(params[:package_id])
    taskToAdd = params[:task_name]
    advertisement_name = "109_" + Time.now.gmtime.strftime("%m%d%Y%H%M%S") + "_PKG" + packageToAdd.remote_id
    packageTasks = packageToAdd.tasks
    puts packageTasks.size.to_s + "tasks to choose from"
    
    if(taskToAdd)
      taskToExecute=nil
      packageTasks.each do |packageTask|
        taskToExecute = packageTask if packageTask.name = taskToAdd
      end
      if taskToExecute
        groupToAddTo.executeTask(taskToExecute, advertisement_name)
        @successString = "Advertisement Created : " + advertisement_name
      else
        @errorString = "ERROR : An invalid task was entered" 
      end
    else
      if packageTasks.size == 1
        groupToAddTo.executeTask(packageToAdd.tasks.first, advertisement_name)
        @successString = "Advertisement Created : " + advertisement_name
      else
        @tasksToChoose = packageTasks
      end
    end
    @group_id = groupToAddTo.remote_id
    @package_id = packageToAdd.remote_id
    get_tabset;
    
    update_page do |page|
      page.hide_spinner
      if (@successString)
        page.redraw_active_tab
        page.set_redbox('add_package_to_group_success')
      elsif (@errorString)
        page.set_redbox('add_package_to_group_error')
      else
        page.set_redbox('add_package_to_group')
      end
    end
  end
  def add_computer_to_group
    puts "Group ID is " + params[:computer_group_id]
    puts "Computer ID is " + params[:computer_id]
    groupToAddTo = SmsComputerGroup.find_by_remote_id(params[:computer_group_id])
    computerToAdd = SmsComputer.find_by_remote_id(params[:computer_id])
    groupToAddTo.addComputer(computerToAdd)
    get_tabset;
    update_page do |page| 
      page.redraw_active_tab
    end
  end
  def create_computer_group
    name = params[:computer_group_name]
    if(false)
      update_page do |page|
        page.redraw_tabset
        page.redraw_item_list
        page.close_redbox
      end
      update_page do |page|
        page.set_redbox('new_computer_group_form')
      end
    else
      update_page do |page|
        page.set_redbox('new_computer_group_form')
      end
    end
  end
  def delete_computer_from_group
    computer_id = params[:computer_id]
    group_id = params[:group_id]
    group = SmsComputerGroup.find(group_id)
    group.removeComputer(computer_id)
    get_tabset;
    update_page do |page| 
      page.redraw_active_tab
    end
  end
  def delete_package_deployment
    deploymentToDelete = SmsPackageDeployment.find(params[:package_deployment_id])
    deploymentToDelete.delete
    get_tabset;
    update_page do |page| 
      page.redraw_active_tab
    end
  end
  def delete_content_from_sidebar
    
    refresh_tabs = false
    content_type = (params[:type]).camelize.constantize;
    content_to_delete = content_type.find(params[:id]);
    if(tab_to_delete = get_tabset.find_open_tab_for_content(content_to_delete))
      puts "I'm going to delete " + tab_to_delete.id.to_s
      tab_to_delete.destroy
      refresh_tabs = true
    end
    puts "Deleting the content, now"
    content_to_delete.destroy
    
    get_tabset
    @sidebar_buttons = get_sidebar_buttons;
    @sidebar_items = perform_search(session[:search_string], @sidebar_buttons)

    update_page do |page|
      page.redraw_tabset if refresh_tabs
      page.redraw_item_list
    end
  end

  # Non-implemented actions
  def import_from_csv
    parsed_file=CSV.parse(params[:dump][:file])
    parsed_file.each  do |row|
      c=Computer.new
      c.serial_number=row[0]
      c.model=row[2]
      c.system_class=row[3]
      c.po_number=row[4]
      c.division_id=row[5]
      c.stage=row[6]
      c.save
      flash.now[:message]="CSV Import Successful, new records added to data base"
    end
  end
  
  # Main Inventory Actions
  # --Manage Licenses
  def add_licensed_computer
    begin
      comp = Computer.find(params[:computer_id])
      pkg = Package.find(params[:package_id])
      comp.add_package(pkg)
      get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      if error.message == "No Licenses Available" then
        @error_msg = "There are no licenses of #{pkg.short_name} available for this division."
      else
        @error_msg = "Unknown Error: #{error.message}"
      end
      get_tabset
      update_page do |page|
        page.set_redbox('error_alert')
      end
    end
  end
  
  # --Manage Computer
  def change_state_of_system
    begin
      @computer = Computer.find(params[:id])
      @new_stage = params[:stage]
      @computer.change_stage(params[:stage], params[:computer])
      get_tabset
      update_page do |page|
        page.close_redbox
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      case error.message
      when "TransitionRequiresDeploymentData"
        redbox_partial = 'edit_deployment_data'
      when "TransitionRequiresLocationData"
        redbox_partial = 'set_location'
      when "TransitionIsIllegal"
        redbox_partial = 'error_alert'
        @error_msg = "You cannot transition legally between these two states"
      else
        redbox_partial = 'error_alert'
        @error_msg = "Unknown Error: #{error.message}"
      end
      @stage = params[:stage]
      update_page do |page|
        page.set_redbox(redbox_partial)
      end  
    end
  end
  def add_licensed_package_or_bundle
    begin
      pkg_or_bundle = params[:pkg_or_bundle].split('_').first
      id = params[:pkg_or_bundle].split('_').last
      @computer = Computer.find(params[:computer_id])
      if pkg_or_bundle == "Package"
        @package = Package.find(id)
        @computer.add_package(@package)
      else
        bundle = Bundle.find(id)
        @computer.add_bundle(bundle)
      end
      @package_maps = PackageMap.find_all_by_package_id(@package.id)
      @package_maps.delete_if do |map|
	map.default_install_task.nil? || map.default_install_task.empty?
      end
      @task_type=:install
    
      get_tabset
      update_page do |page|
        page.redraw_active_tab 
	# page.set_redbox('push_license') if @package
      end
    rescue RuntimeError => error
      if error.message == "No Licenses Available" then
        if @package
          @error_msg = "There are no licenses of #{@package.short_name} available for this division."
        else
          @error_msg = "There are no licenses of #{bundle.short_name} available for this division."
        end
      else
        @error_msg = "Unknown Error: #{error.message}"
      end
      get_tabset
      update_page do |page|
        page.set_redbox('error_alert')
      end
    end
  end
  def remove_licensed_package
    lic = License.find_by_computer_id(params[:computer_id], :conditions => { :package_id => params[:package_id] })
    lic.remove_from_computer
    get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  def trigger_task
    package_map = PackageMap.find(params[:package_map_id])
    task_type = params[:task_type]
    computer = Computer.find(params[:computer_id])
    install_to_computer(computer, package_map)
  end

  def add_installed_peripheral
    begin
      Computer.find(params[:computer_id]).add_peripheral(Peripheral.find(params[:peripheral_id]))
      get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      if error.message == "PeripheralAlreadyAssigned" then
        @error_msg = "This peripheral is already installed on a system"
      elsif error.message == "PeripheralComputerDivisionMismatch"
        @error_msg = "This peripheral is in a different division."
      elsif error.message == "IllegalStageForPeripheralAssignment"
        @error_msg = "This computer is in either disposal or storage."
      else
        @error_msg = "Unknown Error: #{error.message}"
      end
      get_tabset
      update_page do |page|
        page.set_redbox('error_alert')
      end
    end
    package_map = PackageMap.find(params[:package_map_id])
    task_type = params[:task_type]
  end
  def remove_installed_peripheral
    Peripheral.find(params[:peripheral_id]).remove_from_computer
    get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  
  # View Actions
  # --Computer View
  def open_assigned_licenses
    @computer = Computer.find(params[:id])
    @view = params[:view]
    render :partial => "open_disclosure"
  end
  def close_assigned_licenses
    @computer = Computer.find(params[:id])
    @view = params[:view]
    render :partial => "closed_disclosure"
  end
  def open_installed_peripherals
    @computer = Computer.find(params[:id])
    @view = params[:view]
    render :partial => "open_disclosure"
  end
  def close_installed_peripherals
    @computer = Computer.find(params[:id])
    @view = params[:view]
    render :partial => "closed_disclosure"
  end
  def open_current_status
     @computer = Computer.find(params[:id])
     @view = params[:view]
     render :partial => "open_disclosure"
  end
  def close_current_status
    @computer = Computer.find(params[:id])
    @view = params[:view]
    render :partial => "closed_disclosure"
  end
  def open_remote_status(server_name)
    @computer = Computer.find(params[:id])
    @view = params[:view]
    services = service_list(@computer.system_class,
    				                @computer.domain,
    				                "ComputerInformation")
    services.delete_if do |service|
      service.name.sub(" ","_") != server_name
    end
    @service = services[0]
    @title = "Computer Info: #{@service.name}"
    @div = "remote_status__" + @service.name.sub(" ","_")
    @remote_data_sets ||= Hash.new
    begin
      @remote_data_sets[@service.name] = @service.info_for(@computer.serial_number)
    rescue RemoteRecordNotFound
      @view = "#{@view}_no_record"
    end
    render :partial => "open_disclosure"
  end
  def close_remote_status(server_name)
    @computer = Computer.find(params[:id])
    @view = params[:view].sub("_no_record", "")
    services = service_list(@computer.system_class,
    				                @computer.domain,
    				                "ComputerInformation")
    services.delete_if do |service|
      service.name.sub(" ","_") != server_name
    end
    @service = services[0]
    @title = "Computer Info (#{@service.name})"
    @div = "remote_status__" + @service.name.sub(" ","_")
    render :partial => "closed_disclosure"
  end
  def open_advertisements(server_name)
    @computer = Computer.find(params[:id])
    @view = params[:view]
    services = service_list(@computer.system_class,
			    @computer.domain,
			    "SoftwareManagement")
    services.delete_if do |service|
      service.name.sub(" ","_") != server_name
    end
    @service = services[0]
    @title = "Advertisements: #{@service.name}"
    @div = "advertisements__" + @service.name.sub(" ","_")
    @advertisements ||= Hash.new
    begin
      @advertisements[@service.name] = @service.advertisements_for_computer(@computer.serial_number)
    rescue RemoteRecordNotFound
      @view = "#{@view}_no_record"
    end
    render :partial => "open_disclosure"
  end
  def close_advertisements(server_name)
    @computer = Computer.find(params[:id])
    @view = params[:view].sub("_no_record", "")
    services = service_list(@computer.system_class,
    				                @computer.domain,
    				                "ComputerInformation")
    services.delete_if do |service|
      service.name.sub(" ","_") != server_name
    end
    @service = services[0]
    @title = "Advertisements (#{@service.name})"
    @div = "advertisements__" + @service.name.sub(" ","_")
    render :partial => "closed_disclosure"
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
