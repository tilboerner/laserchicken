class UsersController < ApplicationController

  before_filter :require_admin_user

  def index
    @users = User.all
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :password, :is_admin))
    if @user.save
      flash[:success] = "User #{@user.name} created"
      redirect_back_or_rescue
    else
      flash.now[:error] = "User creation failed: #{@user.errors.messages}"
      @users = User.all
      render 'index'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(:name, :password, :is_admin))
      flash[:success] = "User #{@user.name} updated"
      redirect_back_or_rescue
    else
      flash.now[:error] = "User update failed: #{@user.errors.messages}"
      @users = User.all
      render 'index'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "user #{@user.name} deleted"
    redirect_back_or_rescue
  end

end
