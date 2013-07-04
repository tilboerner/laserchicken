class UserStatesController < ApplicationController

  def show
    @user_state = Entry.find(params[:id]).userstate(current_user)
  end

  def update
    newstate = params.require(:user_state).permit(:seen, :starred)
    @user_state = Entry.find(params[:id]).userstate(current_user)
    @user_state.update(newstate)
    redirect_303 :back
  rescue ActionController::RedirectBackError
    render 'show'
  end


end
