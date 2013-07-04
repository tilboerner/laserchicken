module SessionsHelper

	def sign_in(user)
		reset_session	# new session id protects against session attacks
		session[:remember_token] = user.id
		self.current_user = user
	end

	def sign_out
		self.current_user = nil
		reset_session
	end

	def signed_in?
		not current_user.nil?
	end

	def current_user
		if session[:remember_token]
			begin
				@current_user ||= User.find(session[:remember_token])
			rescue ActiveRecord::RecordNotFound
				session.delete(:remember_token)
				return nil
			end
		end
	end

private

	def current_user=(user)
		@current_user = user
	end
end
