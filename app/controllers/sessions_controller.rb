require 'auth.rb'

class SessionsController < ApplicationController
  def new
  end
  
  def create
	if ldap_login(params[:username], params[:password])
		user = User.find_by_username(params[:username])
		if user && user.name
			session[:user_id] = user.id
		elsif user
			user = ldap_populate(user, params[:username], params[:password])
		else
			user = ldap_populate(User.new,params[:username], params[:password])
			session[:user_id] = user.id
		end
		flash[:notice] = "Logged in!"
		redirect_to '/'
	else
		flash[:alert] = "Invalid login."
		redirect_to '/'
	end
  end
  
  def destroy  
    session[:user_id] = nil  
    redirect_to '/sessions/new', :notice => "Logged out!"  
  end  

end
