class UserSessionsController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create]
  filter_resource_access
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'Successfully logged in.'
      redirect_to root_url
    else
      render :action => "new" 
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    flash[:notice] = "Successfully logged out."
    redirect_to(root_url)
  end
end
