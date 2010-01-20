class SiteMapsController < ApplicationController
  # GET /site_maps
  # GET /site_maps.xml
  def index
    @site_maps = SiteMap.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_maps }
    end
  end

  # GET /site_maps/1
  # GET /site_maps/1.xml
  def show
    @site_map = SiteMap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_map }
    end
  end

  # GET /site_maps/new
  # GET /site_maps/new.xml
  def new
    @site_map = SiteMap.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_map }
    end
  end

  # GET /site_maps/1/edit
  def edit
    @site_map = SiteMap.find(params[:id])
  end

  # POST /site_maps
  # POST /site_maps.xml
  def create
    @site_map = SiteMap.new(params[:site_map])

    respond_to do |format|
      if @site_map.save
        flash[:notice] = 'SiteMap was successfully created.'
        format.html { redirect_to(@site_map) }
        format.xml  { render :xml => @site_map, :status => :created, :location => @site_map }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_maps/1
  # PUT /site_maps/1.xml
  def update
    @site_map = SiteMap.find(params[:id])

    respond_to do |format|
      if @site_map.update_attributes(params[:site_map])
        flash[:notice] = 'SiteMap was successfully updated.'
        format.html { redirect_to(@site_map) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_maps/1
  # DELETE /site_maps/1.xml
  def destroy
    @site_map = SiteMap.find(params[:id])
    @site_map.destroy

    respond_to do |format|
      format.html { redirect_to(site_maps_url) }
      format.xml  { head :ok }
    end
  end
end
