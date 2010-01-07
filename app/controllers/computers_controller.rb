class ComputersController < ApplicationController
  filter_access_to :all
  
  def show
    @computer = Computer.find_by_serial_number(params[:id])
    @computer_data = @computer.get_data_set(params[:service_class], params[:service_name]) if params[:service_class]
    respond_to do |format|
      format.html
      format.xml  { render :xml => (@computer_data.empty? ? @computer : @computer_data) }
      format.json  { render :json => (@computer_data.empty? ? @computer : @computer_data) }
      format.js   { render :partial => 'embedded_show'}
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
    if request.xhr?
      render :partial => 'embedded_edit'
    end
  end
  def new
    @computer ||= Computer.new(params[:computer])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @computer }
      format.json { render :json => @computer }
      format.js   { render :update do |page| 
          page.replace_html 'redbox_content', :partial => 'embedded_new'
        end
      }
    end
  end
  def create
    @computer = Computer.new(params[:computer])

    respond_to do |format|
      if @computer.save
        flash[:notice] = 'Computer was successfully created.'
        format.html {redirect_to(computer_path(@computer.serial_number))}
        format.xml  { render :xml => @computer, :status => :created, :location => @computer }
        format.js   {
          render :update do |page|
            page.insert_html :bottom, 'computer_table', :partial => "embedded_computer_row", :locals => {:computer => @computer}
            page.replace_html 'redbox_content', :text => "Computer Creation Successful - #{@computer.short_name}"
          end
        }
      else
        format.html { render :action => "new"  }
        format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
        format.js {
          render :update do |page|
            page.replace_html 'redbox_content', :partial => 'embedded_new'
          end
        }
      end
    end
  end
  def update
    @computer = Computer.find_by_serial_number(params[:id])
    respond_to do |format|
      if @computer.update_attributes(params[:computer])
        flash[:notice] = 'Computer was successfully updated.'
        format.html { redirect_to(@computer) }
        format.xml  { head :ok }
        format.js   { render :partial => 'embedded_show' }
      else
        format.html { render :action => 'edit' }
        format.js   { render :partial => 'embedded_edit'}
        format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
      end
    end
  end
end