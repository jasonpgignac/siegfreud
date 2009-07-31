class MainController < ApplicationController
  
  # page rendering routines
  
  def index
    @tabset = get_tabset;
    @sidebar_items = get_found_set;
	  @sidebar_buttons = get_sidebar_buttons;
  end
  
  def redraw_sidebar
	  @sidebar_items = get_found_set;
	  @sidebar_buttons = get_sidebar_buttons;
	  render :update do |page|
	    page.replace_html 'sidebarwrapper', :partial => 'sidebar'
    end
  end

  # event responders - tabs
  


  def close_tab
    tab = Tab.find(params[:id]);
    if tab.active?
      get_tabset.switch_to_next_tab;
    end
    tab.destroy;
    redraw_tabset;
  end
  
  def close_new_tab
    redraw_tabset
  end
  
  # event responders - content
  
  # Method:   search
  def search
    search_string = (params[:query])
    sidebar_buttons = get_sidebar_buttons;
    sidebar_items = Array.new()
    if(sidebar_buttons["Computers"])
      sidebar_items = sidebar_items + searchForComputersByKeyword(search_string)
    end
    if(sidebar_buttons["Packages"])
      sidebar_items = sidebar_items + searchForComputersByPackages(search_string)
    end
  end
  def save_content
    content_type = (params[:class]).camelize.constantize;

    (params[:id]) ? (content_record = content_type.find(params[:id])) : (content_record = content_type.new());
    content_record.attributes = (params[:content]);
    if content_record.save
      update_found_set;
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def new_content
    content_type = (params[:class]).camelize.constantize;
    @newTab = Tab.create;
    @newTab.content = content_type.new();
    redraw_tabset;
  end
  
  def create_content
     content_type = (params[:class]).camelize.constantize;
     content_record = content_type.new(params[:content])
     content_record.save;
     update_found_set;
     get_tabset.open_and_activate(content_record);
     redirect_to :action => 'index';
  end

  def open_content
    content_type = (params[:type]).camelize.constantize;
    content = (params[:id]) ? content_type.find(params[:id]) : content_type.new();
    get_tabset.open_and_activate(content);
    redraw_tabset;
  end

  def delete_content
    content_type = (params[:type]).camelize.constantize;
    content_type.find(params[:id]).destroy;
    update_found_set;
    redirect_to :action => 'index';
  end
  
  # event responders - assocation handling
  
  def remove_package_from_computer
    comp_id = params[:comp]
    package_id = params[:pkg]
    Computer.find_by_id(comp_id).packages.delete(Package.find_by_id(package_id))
    redirect_to :action => :redraw_tabset;
  end
  
  def add_license_to_computer
    comp_id = params[:comp]
    package_id = params[:pkg]
    Computer.find_by_id(comp_id).packages << (Package.find_by_id(package_id))
    redirect_to :action => :redraw_tabset;
  end
  
  def add_user_to_computer
    comp_id = params[:comp]
    user_id = params[:user]
    logger.info { "Computer " + comp_id + " - User " + user_id }
    computer = Computer.find_by_id(comp_id)
    computer.user = User.find_by_id(user_id)
    computer.save
    
    redirect_to :action => :redraw_tabset;
  end
  
  def update_sidebar_filter
   	if (params[:value] == '1')
   	  session[:sidebar_buttons][params[:id]] = true;
   	else
   	  session[:sidebar_buttons][params[:id]] = false;
   	end
   	update_found_set;
   	redirect_to :action => 'redraw_sidebar';
  end

  def new_action_for_package
    
  end
  
  def remove_action_from_package
    
  end

  # event responders - outputs
   
  def output_prestage_file
    
    
  end
  
  private
  
  # Session Variable Management
  
  def get_found_set
    if (session[:found]) 
      return session[:found]
    else
      update_found_set;
      return session[:found]
    end
  end
  def update_found_set
    foundset = Array.new;
    sidebar_buttons = get_sidebar_buttons;
    search_field = get_search_field;
    if (search_field)
      #if(sidebar_buttons["Packages"])
      #  foundset = foundset + searchForComputersByKeyword
      #end
      if(sidebar_buttons["Computers"])
        foundset = foundset + searchForComputersByKeyword(search_field)
      end
      #if(sidebar_buttons["Users"])
      #  foundset = foundset + User.find(:all)
      #end
      #if(sidebar_buttons["Departments"])
      #  foundset = foundset + Department.find(:all)
      #end
    end if
    session[:found] = foundset;
  end
  def get_tabset
    unless (session[:tabset_id])
      session[:tabset_id] = Tabset.create.id;
    end
    return Tabset.find(session[:tabset_id]);
  end
  def get_search_field
    if (session[:search_field])
      return session[:search_field]
    else
      return session[:search_field] = "umartar"
    end
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

end
