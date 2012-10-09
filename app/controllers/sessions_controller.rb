require 'auth.rb'

class SessionsController < ApplicationController
  def new
  end
  
  def create
	if ldap_login(params[:username], params[:password])
		user = User.find_by_username(params[:username])
		if user && user.name
			session[:user_id] = user.id
			flash[:notice] = "Logged in!"
		elsif user
			user = ldap_populate(user, params[:username], params[:password])
			flash[:notice] = "Welcome!"
		else
			user = ldap_populate(User.new,params[:username], params[:password])
			session[:user_id] = user.id
			flash[:notice] = "Welcome to BAS!"
		end
		redirect_to '/'
	else
		flash[:notice] = "Invalid login."
		redirect_to '/'
	end
  end
  
  def destroy  
	flash[:notice] = "Logged out" if session[:user_id]
    session[:user_id] = nil  
    redirect_to '/sessions/new'
  end  

end
