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
  def add_inventory
    puts "Division: " + params[:division].to_s
    puts "PO: " + params[:po_number].to_s
    if(params[:division].nil? || params[:po_number].nil?)
      redirect_to :action => "start_new_po"
    else
      @division = params[:division]
      @po_number = params[:po_number]
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
      c.division=row[5]
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
      comp = Computer.find(params[:computer_id])
      if pkg_or_bundle == "Package"
        pkg = Package.find(id)
        comp.add_package(pkg)
      else
        bundle = Bundle.find(id)
        comp.add_bundle(bundle)
      end
      get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      if error.message == "No Licenses Available" then
        if pkg
          @error_msg = "There are no licenses of #{pkg.short_name} available for this division."
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
    
  end
  def remove_installed_peripheral
    Peripheral.find(params[:peripheral_id]).remove_from_computer
    get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  
  private
  
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
    foundset = Array.new;
    if (search_field)
      foundset = foundset + Computer.search(search_field)
      foundset = foundset + Package.search(search_field)
      foundset = foundset + Bundle.search(search_field)
      foundset = foundset + Peripheral.search(search_field)
    end
  end
  def get_active_content
    if @tabset.active_tab?
      ivarsym = "@#{@tabset.active_tab.content.class.to_s.downcase}".to_sym
      self.instance_variable_set(ivarsym, @tabset.active_tab.content)
    end
  end
  def get_tabset
    unless (session[:tabset_id])
      session[:tabset_id] = Tabset.create.id;
    end
    @tabset = Tabset.find(session[:tabset_id])
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
  def hash_to_html_select_options
    
  end
end
