class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper

  before_action :require_logged_in_user
  before_action { establish_context }

  def handle_unverified_request
  	sign_out
  	super
  end

  def require_admin_user(options = {})
    unless options[:exception] or (signed_in? && current_user.is_admin?)
      flash[:error] = 'access unauthorized'
      redirect_to root_path, status: :forbidden
    end
  end

  def require_logged_in_user
    if User.exists?
      redirect_303 login_path unless signed_in? or [login_path, sessions_path].include? request.fullpath
    else
      redirect_303 new_user_path unless [new_user_path, users_path].include? request.fullpath
    end
  end

  def call_rake(task, options = {})
    logfile = "#{Rails.root}/log/rake.log"
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "/usr/bin/rake #{task} #{args.join(' ')} >> #{logfile} 2>> #{logfile} &"
  end


end
