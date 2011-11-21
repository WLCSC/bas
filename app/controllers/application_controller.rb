class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  private
  
  def current_user
	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def check_for_user
    redirect_to '/sessions/new' unless current_user
  end
  
  def check_for_admin
    redirect_to '/home/index' unless current_user && current_user.admin?
  end
end
