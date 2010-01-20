class AuditsController < ApplicationController
  def new
    @domains = Domain.all
    @servers = Server.all
    @sites = Site.all
  end

  def create
    redirect_to(audit_path(params[:id]))
  end
  def show
    @audit = Audit.new(:server_id => params["server_id"], :site_id => params["site_id"], :domain_id => params["domain_id"], :platform => params["platform"])
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
