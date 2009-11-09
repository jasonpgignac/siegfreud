class ComputersController < ApplicationController
  def show
    @computer = Computer.find_by_serial_number(params[:id])
    if(params[:data_set])
      @computer_data = @computer.get_data_set(params[:data_set], params[:server_name])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @computer_data ? @computer_data : @computer }
      format.json  { render :json => @computer_data ? @computer_data : @computer }
    end
  end
  def index
    conditions = Hash.new
    conditions[:division_id] = params[:division_id] if params[:division_id]
    conditions[:stage_id] = params[:stage_id] if params[:stage_id]
    unless conditions.empty?
      @computers = Computer.find(:all, :conditions => conditions)  
    else
      @computers = Computer.find(:all)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml   => @computers }
      format.json { render :json  => @computers }
      format.pdf
    end
  end
  def destroy
    @computer = Computer.find_by_serial_number(params[:id])
    deleted = false
    if(@computer)
      @computer.destroy
      deleted = true
    end
    respond_to do |format|
      if(deleted)
        flash[:notice] = "The computer has been deleted successfully."
        format.html { redirect_to(computers_url) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        flash[:error] = "Deletion failed: No computer with the serial number '#{params[:id]}' could be found"
        format.html { redirect_to(computers_url) }
        format.xml  { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404}
        format.json { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404}
      end
    end
  end
  def edit
    @computer ||= Computer.find_by_serial_number(params[:id])
  end
  def new
    @computer ||= Computer.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @computer }
      format.json { render :json => @computer }
    end
  end
  def create
    @computer = Computer.new(params[:computer])

      respond_to do |format|
        if @computer.save
          flash[:notice] = 'Computer was successfully created.'
          format.html { redirect_to(computer_path(@computer.serial_number)) }
          format.xml  { render :xml => @computer, :status => :created, :location => @computer }
        else
          format.html { redirect_to new_computer_path }
          format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
        end
      end
  end
  def update
    @computer = Computer.find_by_serial_number(params[:id])

    respond_to do |format|
      if @computer.update_attributes(params[:computer])
        flash[:notice] = 'Computer was successfully updated.'
        format.html { redirect_to(computer_path(@computer.serial_number)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(edit_computer_path(@computer.serial_number)) }
        format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
      end
    end
  end
end