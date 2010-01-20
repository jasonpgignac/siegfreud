class AuditsController < ApplicationController
  def new
    @audit = Audit.new
    @domains = Domain.all
    @servers = Server.all
    @sites = Site.all
  end

  def create
    redirect_to(audit_path("computers", :audit => params[:audit]))
  end
  def show
    @audit = Audit.new(params[:audit])
    if @audit.valid?
      respond_to do |format|
        format.html
        format.xml  { render :xml => @audit }
        format.json  { render :json => @audit }
      end
    else
      redirect_to(new_audit_path)
    end
  end

end
