class SessionsController < ApplicationController
	
	def new
	end

	def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:username], params[:session][:password])
      flash[:notice] = 'Signin Successfull' # Not quite right!
      redirect_to user
    else
      flash[:error] = 'Invalid username/password combination'
      redirect_to '/'
    end
  end

	def destroy
    params.delete(:session);
    redirect_to '/'
	end

end
