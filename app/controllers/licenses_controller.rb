class LicensesController < ApplicationController
  # GET /licenses
  # GET /licenses.xml
  def index
    @licenses = params[:computer_id] ? Computer.find_by_serial_number(params[:computer_id]).licenses : License.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @licenses }
      format.json { render :json => @licenses.size == 0 ? @licenses : @licenses.to_json(:include => :package) }
    end
  end

  # GET /licenses/1
  # GET /licenses/1.xml
  def show
    @license = License.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @license }
      format.json { render :json => @license }
    end
  end

  # GET /licenses/new
  # GET /licenses/new.xml
  def new
    @license = License.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @license }
    end
  end

  # GET /licenses/1/edit
  def edit
    @license = License.find(params[:id])
  end

  # POST /licenses
  # POST /licenses.xml
  def create
    @license = License.new(params[:license])

    respond_to do |format|
      if @license.save
        flash[:notice] = 'License was successfully created.'
        format.html { redirect_to(@license) }
        format.xml  { render :xml => @license, :status => :created, :location => @license }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /licenses/1
  # PUT /licenses/1.xml
  def update
    @license = License.find(params[:id])

    respond_to do |format|
      if @license.update_attributes(params[:license])
        flash[:notice] = 'License was successfully updated.'
        format.html { redirect_to(@license) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @license.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.xml
  def destroy
    @license = License.find(params[:id])
    @license.destroy

    respond_to do |format|
      format.html { redirect_to(licenses_url) }
      format.xml  { head :ok }
    end
  end
end
