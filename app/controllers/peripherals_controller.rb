class PeripheralsController < ApplicationController
  # GET /peripherals
  # GET /peripherals.xml
  def index
    conditions = Hash.new
    all_periphs = params[:computer_id] ? Computer.find_by_serial_number(params[:computer_id]).peripherals : Peripheral
    conditions[:division_id] = params[:division_id] if params[:division_id]
    conditions[:stage_id] = params[:stage_id] if params[:stage_id]
    unless conditions.empty?
      @peripherals = all_periphs.find(:all, :conditions => conditions)  
    else
      @peripherals = all_periphs.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml   => @peripherals }
      format.json { render :json  => @peripherals }
    end
  end

  # GET /peripherals/1
  # GET /peripherals/1.xml
  def show
    @peripheral = Peripheral.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @peripheral }
    end
  end

  # GET /peripherals/new
  # GET /peripherals/new.xml
  def new
    @peripheral = Peripheral.new(params[:peripheral])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @peripheral }
      format.js   { 
        render :update do |page| 
          page.replace_html 'redbox_content', :partial => 'embedded_new'
        end
      }
    end
  end

  # GET /peripherals/1/edit
  def edit
    @peripheral = Peripheral.find(params[:id])
     if request.xhr?
        render :partial => 'embedded_edit'
      end
  end

  # POST /peripherals
  # POST /peripherals.xml
  def create
    params[:peripheral][:stage_id] = nil if params[:peripheral][:stage_id] == '0'
    if params[:computer_name] && params[:peripheral][:stage_id].nil?
      c = Computer.find_by_name(params[:computer_name])
      if c
        params[:peripheral][:computer_id] = c.id
      else
        params[:peripheral][:computer_id] = nil
      end
    end
    @peripheral = Peripheral.new(params[:peripheral])
    respond_to do |format|
      if @peripheral.save
        flash[:notice] = 'Peripheral was successfully created.'
        Action.create_with_inventory_objects("Created Peripheral", "#{params[:peripheral]}", [ @peripheral ], current_user)
        format.html { redirect_to(@peripheral) }
        format.xml  { render :xml => @peripheral, :status => :created, :location => @peripheral }
        format.js   {
          render :update do |page|
            page.insert_html :bottom, 'peripheral_table', :partial => "embedded_peripheral_row", :locals => {:periph => @peripheral}
            page.replace_html 'redbox_content', :text => "Peripheral Creation Successful - #{@peripheral.short_name}"
          end
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @peripheral.errors, :status => :unprocessable_entity }
        format.js {
          render :update do |page|
            page.replace_html 'redbox_content', :partial => 'embedded_new'
          end
        }
      end
    end
  end

  # PUT /peripherals/1
  # PUT /peripherals/1.xml
  def update
    @peripheral = Peripheral.find(params[:id])
    params[:peripheral][:stage_id] = Stage.find_by_name("Storage").id if params[:peripheral][:stage_id] == "first"
    params[:peripheral][:stage_id] = nil if params[:peripheral][:stage_id] == '0'
    if params[:computer_name] && params[:peripheral][:stage_id].nil?
      c = Computer.find_by_name(params[:computer_name])
      if c
        params[:peripheral][:computer_id] = c.id
      else
        params[:peripheral][:computer_id] = nil
      end
    end
    params[:peripheral][:computer_id] = nil if params[:peripheral][:stage_id] != nil
    if params[:peripheral].size == 1 && params[:peripheral][:computer_id]
      if params[:peripheral][:computer_id].to_s == @peripheral.computer_id.to_s
        @peripheral.errors.add_to_base("Peripheral is already assigned to this computer")
      end
    end
    @peripheral.attributes = params[:peripheral]
    changes = @peripheral.changes
    respond_to do |format|
      if @peripheral.errors.size == 0 && @peripheral.save
        Action.create_with_inventory_objects("Updated Peripheral", "#{changes}", [ @peripheral ], current_user)
        flash[:notice] = 'Peripheral was successfully updated.'
        format.html { redirect_to(@peripheral) }
        format.xml  { head :ok }
        format.js   { render :partial => 'embedded_show' }
        format.json { render :json => @peripheral}
      else
        format.html {
          render :action => "edit" 
        }
        format.xml  { render :xml => @peripheral.errors, :status => :unprocessable_entity }
        format.js   { render :partial => 'embedded_edit'}
        format.json { render :json => @peripheral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peripherals/1
  # DELETE /peripherals/1.xml
  def destroy
    @peripheral = Peripheral.find(params[:id])
    if @peripheral
      @peripheral.destroy
      Action.create_with_inventory_objects("Deleted Perihperal", "", [ @peripheral ], current_user)
      respond_to do |format|
        format.html { redirect_to(peripherals_url) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:error] = "Deletion failed: No peripheral with the id '#{params[:id]}' could be found"
        format.html { redirect_to(peripherals_url) }
        format.xml  { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404}
        format.json { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404}
      end
    end
  end
  
end
