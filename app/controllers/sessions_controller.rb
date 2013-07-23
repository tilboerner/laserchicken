class SessionsController < ApplicationController

	def new
		if signed_in?
			redirect_303 root_path
		end
	end

	def create
		name, password = params.require(:session).permit(:name, :password).values
		user = User.find_by_name(name)
		if user and user.authenticate(password)
			sign_in user
			flash[:info] = "Signed in as #{name}"
			redirect_303 root_path
		else
			flash[:error] = 'Invalid name or password'
			redirect_303 login_path
		end
	end

	def destroy
		sign_out
		redirect_303 root_path
	end

end
