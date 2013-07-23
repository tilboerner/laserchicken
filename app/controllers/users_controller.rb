class UsersController < ApplicationController

  before_action  { require_admin_user(exception: !User.exists?) }

  def index
    @users = User.all
  end

  def new
    @user = User.new(is_admin: !User.exists?)
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :password, :is_admin))
    if User.exists?
      persist_user
    else
      persist_first_user
    end
  end

  def update
    if @user.update(params.require(:user).permit(:name, :password, :is_admin))
      flash[:info] = "User #{@user.name} updated"
      redirect_back_or_rescue
    else
      flash[:error] =  "Cannot update user #{@user.name}: " + get_model_errors
      redirect_back_or_rescue
    end
  end

  def destroy
    @user.destroy!
    flash[:notice] = "user #{@user.name} deleted"
    redirect_back_or_rescue
  rescue ActiveRecord::RecordNotDestroyed
    flash[:error] = "Cannot delete user #{@user.name}: " + get_model_errors
    redirect_back_or_rescue
  end

private

  def persist_user
    if @user.save
      flash[:info] = "User #{@user.name} created"
      redirect_back_or_rescue
    else
      flash[:error] = "Cannot create user: " + get_model_errors(@user)
      redirect_back_or_rescue
    end
  end

  def persist_first_user
    if @user.save
      sign_in(@user)
      flash[:info] = "Welcome to #{@appname}, #{@user.name}!"
      redirect_303 root_path
    else
      flash.now[:error] = "Cannot create user: " + get_model_errors(@user)
      render 'new'
    end
  end

end
