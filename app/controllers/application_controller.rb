class ApplicationController < ActionController::Base
  before_filter :authenticate
  before_filter { |c| Authorization.current_user = c.current_user }
  
  helper :all # include all helpers, all the time
  protect_from_forgery #:secret => '052cb93edcaaa126e814e2908a5faaed'
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user
  
  def authenticate
    redirect_to login_path unless (current_user | (ENV["RAILS_ENV"].capitalize == "Test"))
  end
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
