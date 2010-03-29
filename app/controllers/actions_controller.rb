class ActionsController < ApplicationController
  layout 'main'
  def index
    @inventory_object = find_inventory_object
    @actions = @inventory_object.actions.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @actions }
    end
  end

  # GET /actions/1
  # GET /actions/1.xml
  def show
    @action = Action.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @action }
    end
  end

  private
  
  def find_inventory_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        the_class = $1.classify.constantize
        return the_class.find_by_serial_number(value) if the_class = Computer
        return the_class.find(value)
      end
    end
    nil
  end

end
