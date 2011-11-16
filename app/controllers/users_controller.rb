require 'auth.rb'

class UsersController < ApplicationController
before_filter :check_for_admin
  def index
	@users = User.all
  end

  def new
  end
  
  def show
	@user = User.find(params[:id])
  end
  
  def force
	if ldap_search(params[:username]) 
		if User.where(:username => params[:username]).length == 0
			@user = User.new
			@user.username = params[:username]
			@user.save
		else
			flash[:error] = "User already exists"
			redirect_to users_path
		end
		flash[:notice] = "Created user"
		redirect_to users_path
	else
		flash[:error] = "Can't find LDAP User"
		redirect_to users_path
	end
	
  end

end
