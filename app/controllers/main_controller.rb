class MainController < ApplicationController
  
  # response routines
  def index
    @tabset = get_tabset;
	  @sidebar_buttons = get_sidebar_buttons;
  end
  def search
    session[:search_string] = params[:query]
    @tabset = get_tabset;
    #@sidebar_buttons = get_sidebar_buttons;
    @sidebar_items = perform_search(session[:search_string], @sidebar_buttons)
    update_page do |page|
      page.redraw_item_list
    end
  end
  def open_content
    content_type = (params[:type]).camelize.constantize;
    content = (params[:id]) ? content_type.find(params[:id]) : content_type.new();
    get_tabset.open_and_activate(content);
    @tabset = get_tabset;
    update_page do |page|
      page.redraw_tabset;
    end
  end
  def select_tab
    @tabset = get_tabset;
    @tabset.active_tab=(Tab.find(params[:id]));
    @tabset.save;
    update_page do |page|
      page.redraw_tabset;
    end
  end
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
    @tabset = get_tabset;
    
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
    @tabset = get_tabset;
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
    @tabset = get_tabset;
    update_page do |page| 
      page.redraw_active_tab
    end
  end
  def delete_package_deployment
    deploymentToDelete = SmsPackageDeployment.find(params[:package_deployment_id])
    deploymentToDelete.delete
    @tabset = get_tabset;
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
    
    @tabset = get_tabset
    @sidebar_buttons = get_sidebar_buttons;
    @sidebar_items = perform_search(session[:search_string], @sidebar_buttons)

    update_page do |page|
      page.redraw_tabset if refresh_tabs
      page.redraw_item_list
    end
  end
  def close_tab
    tab = Tab.find(params[:id]);
    tab.delete;
    @tabset = get_tabset;
    update_page do |page|
      page.redraw_tabset
    end
  end
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
  def add_inventory
    puts "Division: " + params[:division].to_s
    puts "PO: " + params[:po_number].to_s
    if(params[:division].nil? || params[:po_number].nil?)
      puts "Epic Fail!"
      redirect_to :action => "start_new_po"
    else
      puts "OK! Let's add_inventory!"
      @division = params[:division]
      @po_number = params[:po_number]
    end
  end
  
  def remove_licensed_computer
    lic = License.find_by_computer_id(params[:computer_id], :conditions => { :package_id => params[:package_id] })
    lic.computer_id = nil
    lic.save
    @tabset = get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  def add_licensed_computer
    begin
      comp = Computer.find(params[:computer_id])
      pkg = Package.find(params[:package_id])
      lic = pkg.get_open_license(comp.division)
      lic.computer = comp
      lic.save
      @tabset = get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      if error.message == "No Licenses Available" then
        @tabset = get_tabset
        update_page do |page|
          page.set_redbox('license_not_found')
        end
      else
        throw
      end
    end
  end
  
  def change_state_of_system
    comp = Computer.find(params[:id])
    old_stage = comp.stage
    new_stage = params[:stage]
    if (old_stage == "Repair")
      comp.stage = params[:stage]
      comp.last_stage_change = Date.today;
      comp.save
    else
      case [old_stage, new_stage]
      when  ["Storage", "Rollout"], 
            ["Storage", "Active"]
        redbox_partial = 'edit_deployment_data'    
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Storage", "Repair"], 
            ["Active", "Repair"]
        # Commented out this temporarily, until we put in ticketing system
        # redbox_partial = 'set_ticket_data'  
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Rollout", "Storage"], 
            ["Rollout", "Disposal"],
            ["Active", "Storage"],
            ["Active", "Disposal"],
            ["Repair", "Storage"],
            ["Retrieval", "Storage"],
            ["Retrieval", "Disposal"]
        comp.clear_deployment_data
        redbox_partial = 'set_location'
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Active", "Retrieval"], # Good!
            ["Rollout", "Retrieval"],
            ["Disposal", "Storage"]
        redbox_partial = 'set_location'
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Rollout", "Active"]
        # do nothing
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Rollout", "Repair"]
        clear_deployment_data
        # redbox_partial = 'set_ticket_data'
        comp.stage = params[:stage]
        comp.last_stage_change = Date.today;
        comp.save
      when  ["Storage", "Retrieval"],
            ["Active", "Rollout"],
            ["Retrieval", "Rollout"],
            ["Retrieval", "Active"],
            ["Disposal", "Rollout"],
            ["Disposal", "Active"],
            ["Disposal", "Retrieval"],
        @error_msg = "Siegfreud will not let you change directly from " + old_stage + " to " + new_stage + "."
        redbox_partial = 'error_alert'
      else  
        @error_msg = "Siegfreud does not recognize either the stage " + old_stage + " or " + new_stage + "."
        redbox_partial = 'error_alert'
      end
    end
    @tabset = get_tabset
    update_page do |page|
      page.redraw_active_tab
      unless(redbox_partial.nil?)
        page.set_redbox(redbox_partial)
      end
    end
  end
  def save_edited_computer_deployment_data
    @computer = Computer.find(params[:id])
    if @computer.update_attributes(params[:computer])
      @computer.delta=true
      @computer.save
      @tabset = get_tabset
      update_page do |page|
        page.close_redbox
        page.redraw_active_tab
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
        lic = pkg.get_open_license(comp.division)
        lic.computer = comp
        lic.save
      else
        bundle = Bundle.find(id)
        lics = bundle.get_open_licenses(comp.division)
        lics.each do |lic|
          
          lic.computer = comp
          lic.save
        end
      end
      @tabset = get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    rescue RuntimeError => error
      if error.message == "No Licenses Available" then
        @tabset = get_tabset
        @error_msg = "Unfortunately, this division has no licenses available for this product."
        update_page do |page|
          page.set_redbox('error_alert')
        end
      else
        throw
      end
    end
  end
  def remove_licensed_package
    lic = License.find_by_computer_id(params[:computer_id], :conditions => { :package_id => params[:package_id] })
    lic.computer_id = nil
    lic.save
    @tabset = get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  def add_installed_peripheral
    periph = Peripheral.find(params[:peripheral_id])
    comp = Computer.find(params[:computer_id])
    if(periph.computer_id.nil? && periph.division == comp.division && comp.stage != "Storage" && comp.stage != "Disposal")
      periph.computer = comp
      periph.save
      @tabset = get_tabset
      update_page do |page|
        page.redraw_active_tab
      end
    else
      @tabset = get_tabset
      @error_msg = "Errors in adding this peripheral:"
      unless(periph.computer_id.nil?)
        @error_msg = @error_msg + "<br />This peripheral is already installed on a system"
      end
      if(periph.division != comp.division)
        @error_msg = @error_msg + "<br />This peripheral is in division " + periph.division.to_s + " while the computer is in division " + comp.division.to_s + "."
      end
      if(comp.stage == "Storage" || comp.stage = "Disposal")
        @error_msg = @error_msg + "<br />This computer is in " + comp.stage + "."
      end
      update_page do |page|
        page.set_redbox('error_alert')
      end
    end
  end
  def remove_installed_peripheral
    periph = Peripheral.find(params[:peripheral_id])
    periph.computer_id = nil
    periph.save
    @tabset = get_tabset
    update_page do |page|
      page.redraw_active_tab
    end
  end
  def make_new_computer_in_po
    @po_number = params[:po_number]
    @division = params[:division]
    @computer = Computer.new()
    @computer.last_stage_change = Date.today;
    @computer.po_number = @po_number
    @computer.division = @division
    @computer.stage = "Storage"
    @computer.save
    update_page do |page|
      page.set_redbox('edit_computer_form')
    end
  end
  def edit_computer
    @po_number = params[:po_number]
    @division = params[:division]
    id = params[:id]
    @computer = Computer.find(id)
    row_id = "new_computer_" + @computer.id.to_s
    update_page do |page|
      page.set_redbox('edit_computer_form')
    end
  end
  def save_edited_computer
    @computer = Computer.find(params[:id])
    @po_number = @computer.po_number
    @division = @computer.division
    if @computer.update_attributes(params[:computer])
      flash[:notice] = 'Computer was successfully updated.'
      update_page do |page|
        page.close_redbox
        page.redraw_new_computers
      end
    else
    end
  end
  def delete_computer_from_po
    @po_number = params[:po_number]
    @division = params[:division]
    Computer.find(params[:id]).delete
    update_page do |page|
      page.redraw_new_computers
    end
  end
  def computer_manifest
  end
  
  def remove_computer_from_peripheral
  end
  def add_computer_to_peripheral
  end
  
  def make_new_peripheral_in_po
    @po_number = params[:po_number]
    @division = params[:division]
    @periph = Peripheral.new()
    @periph.po_number = @po_number
    @periph.division = @division
    @periph.save
    update_page do |page|
      page.set_redbox('edit_peripheral_form')
    end
  end
  def edit_peripheral
    @po_number = params[:po_number]
    @division = params[:division]
    id = params[:id]
    @computer = Computer.find(id)
    row_id = "new_periph_" + @computer.id.to_s
    update_page do |page|
      page.set_redbox('edit_peripheral_form')
    end
  end
  def save_edited_peripheral
    @periph = Peripheral.find(params[:id])
    @po_number = @periph.po_number
    @division = @periph.division
    if @periph.update_attributes(params[:peripheral])
      flash[:notice] = 'Computer was successfully updated.'
      update_page do |page|
        page.close_redbox
        page.redraw_new_peripherals
      end
    else
    end
  end
  def delete_peripheral_from_po
    @po_number = params[:po_number]
    @division = params[:division]
    Peripheral.find(params[:id]).delete
    update_page do |page|
      page.redraw_new_peripherals
    end
  end
  
  def make_new_license_in_po
    @po_number = params[:po_number]
    @division = params[:division]
    update_page do |page|
      page.set_redbox('new_license_form')
    end
  end
  def confirm_new_license
    @po_number = params[:po_number]
    @division = params[:division]
    @quantity = params[:quantity]
    packages = Package.search(params[:search_string])
    @select_options = ""
    packages.each do |pkg|
      @select_options = @select_options + "<option value=\"" + pkg.id.to_s + "\">" + pkg.short_name + "</option>"
    end
    @group_license = true
    update_page do |page|
      page.switch_to_package_search_results_in_redbox
    end
  end
  def change_new_licenses_state
    @quantity = params[:id]
    @group_license = params[:group_license]
    update_page do |page|
      page.update_new_license_licensing
    end
  end
  def save_new_license
    pkg = Package.find(params[:package_id])
    @po_number = params[:po_number]
    @division = params[:division]
    quantity = params[:quantity]
    group_license = params[:group_license]
    
    quantity.to_i.times do |i|
      new_license = License.new
      new_license.po_number = @po_number
      new_license.division = @divison
      new_license.package = pkg
      new_license.group_license = (group_license ? true : false )
      if(group_license)
        license_number = params['license_number']
      else
        license_number = params['license_number_' + (i + 1).to_s]
      end
      new_license.save
    end  
    update_page do |page|
      page.close_redbox
      page.redraw_new_licenses
    end
  end
  def delete_license_from_po
    @po_number = params[:po_number]
    @division = params[:division]
    License.find_all_by_po_number(@po_number, :conditions => ["package_id = ?", params[:id]]).each do |lic|
      lic.delete
    end
    update_page do |page|
      page.redraw_new_licenses
    end
  end
  
  def make_new_bundle_in_po
    @po_number = params[:po_number]
    @division = params[:division]
    puts "Division is " + @division
    @bundles = Array.new()
    Bundle.find(:all).each do |bndl|
      @bundles << [bndl.name, bndl.id]
    end
    update_page do |page|
      page.set_redbox('new_bundle_form')
    end
  end
  def save_new_bundle
    bundle_to_add = Bundle.find(params[:id])
    @po_number = params[:po_number]
    @division = params[:division]
    quantity = params[:quantity]
    bundle_to_add.packages.each do |pkg|
      quantity.to_i.times do
        new_license = License.new
        new_license.po_number = @po_number
        new_license.division = @division
        new_license.package = pkg
        new_license.save
      end
    end
    update_page do |page|
      page.close_redbox
      page.redraw_new_licenses
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
  def get_tabset
    unless (session[:tabset_id])
      session[:tabset_id] = Tabset.create.id;
    end
    return Tabset.find(session[:tabset_id]);
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
