class PackageMapsController < ApplicationController
  before_filter :atify_package
  # GET /package_maps
  # GET /package_maps.xml
  def index
    @package_maps = @package.package_maps

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_maps }
    end
  end

  # GET /package_maps/1
  # GET /package_maps/1.xml
  def show
    @package_map = PackageMap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_map }
    end
  end

  # GET /package_maps/new
  # GET /package_maps/new.xml
  def new
    @package_map = PackageMap.new
    
    # Service Info Initialization
    make_service_list
    @package_map.service_name ||=  @service_list[0][1]
    @service = get_service_matching_name(@package_map.service_name)
    
    initialize_remote_package_data
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_map }
    end
  end

  # GET /package_maps/1/edit
  def edit
    @package_map = PackageMap.find(params[:id])
  end

  # POST /package_maps
  # POST /package_maps.xml
  def create
    @package_map = PackageMap.new(params[:package_map])
    @package_map.package = @package
    respond_to do |format|
      if @package_map.save
        flash[:notice] = 'PackageMap was successfully created.'
        format.html { redirect_to(package_maps_path(@package)) }
        format.xml  { render :xml => @package_map, :status => :created, :location => @package_map }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def research_packages
    @package_map = PackageMap.new
    @package_map.service_name = params[:service]
    @service = get_service_matching_name(@package_map.service_name)
    initialize_remote_package_data

    render :update do |page|
      page.replace_html 'remote_package_data', :partial => 'remote_package_data'
    end
  end

  def research_tasks
    @package_map = PackageMap.new
    @package_map.service_name = params[:service]
    @package_map.remote_package_id = params[:remote_package_id]
    @service = get_service_matching_name(@package_map.service_name)
    initialize_remote_package_tasks_data

    render :update do |page|
      page.replace_html 'remote_package_task_data', :partial => 'remote_package_task_data'
    end
  end

  # PUT /package_maps/1
  # PUT /package_maps/1.xml
  def update
    @package_map = PackageMap.find(params[:id])

    respond_to do |format|
      if @package_map.update_attributes(params[:package_map])
        flash[:notice] = 'PackageMap was successfully updated.'
        format.html { redirect_to(@package_map) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_maps/1
  # DELETE /package_maps/1.xml
  def destroy
    @package_map = PackageMap.find(params[:id])
    @package_map.destroy

    respond_to do |format|
      format.html { redirect_to(package_maps_path(@package)) }
      format.xml  { head :ok }
    end
  end

  private
  def get_service_matching_name(name)
    this_service = nil
    @services.each do |platform, domains|
      domains.each do |domain, service_types|
	service_types["PackageInformation"].each do |service|
	  this_service = service if service.name == name
	end
      end
    end
    
    return this_service
  end
  def atify_package
    @package = Package.find(params[:package_id])
  end
  def initialize_remote_package_data
    # Remote Package Info Initialization
    @query = params[:query] || Package.find(params[:package_id].to_i).short_name
    @packages = @service.search(@query)
    @package_map.remote_package_id ||= @packages[0]["id"]
    initialize_remote_package_tasks_data
  end
  def initialize_remote_package_tasks_data
    # Remote Package Tasks Info Initialization
    @tasks = @service.tasks_for_package(@package_map.remote_package_id)
    @package_map.default_install_task ||= @tasks[0] ? @tasks[0][:name] : nil
    @package_map.default_uninstall_task ||= @tasks[1] ? @tasks[1][:name] : nil
  end
  def make_service_list
    @service_list = Array.new
    @services.each do |platform, domains|
      domains.each do |domain, service_types|
	service_types["PackageInformation"].each do |service|
	  @service_list << ["#{service.name} (#{platform} in #{domain})", service.name]
	end
      end
    end
  end
end
