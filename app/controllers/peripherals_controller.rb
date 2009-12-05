class PeripheralsController < ApplicationController
  # GET /peripherals
  # GET /peripherals.xml
  def index
    conditions = Hash.new
    conditions[:division_id] = params[:division_id] if params[:division_id]
    conditions[:stage_id] = params[:stage_id] if params[:stage_id]
    unless conditions.empty?
      @peripherals = Peripheral.find(:all, :conditions => conditions)  
    else
      @peripherals = Peripheral.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @peripherals }
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
    @peripheral = Peripheral.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @peripheral }
    end
  end

  # GET /peripherals/1/edit
  def edit
    @peripheral = Peripheral.find(params[:id])
  end

  # POST /peripherals
  # POST /peripherals.xml
  def create
    @peripheral = Peripheral.new(params[:peripheral])

    respond_to do |format|
      if @peripheral.save
        flash[:notice] = 'Peripheral was successfully created.'
        format.html { redirect_to(@peripheral) }
        format.xml  { render :xml => @peripheral, :status => :created, :location => @peripheral }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @peripheral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /peripherals/1
  # PUT /peripherals/1.xml
  def update
    @peripheral = Peripheral.find(params[:id])

    respond_to do |format|
      if @peripheral.update_attributes(params[:peripheral])
        flash[:notice] = 'Peripheral was successfully updated.'
        format.html { redirect_to(@peripheral) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @peripheral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peripherals/1
  # DELETE /peripherals/1.xml
  def destroy
    @peripheral = Peripheral.find(params[:id])
    if @peripheral
      @peripheral.destroy

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
