class PeripheralsController < ApplicationController
  # GET /peripherals
  # GET /peripherals.xml
  def index
    @peripherals = Peripheral.all

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
    @peripheral.destroy

    respond_to do |format|
      format.html { redirect_to(peripherals_url) }
      format.xml  { head :ok }
    end
  end
end
