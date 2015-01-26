class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
    unless @admin == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user || @admin == current_user
      redirect_to root_path, :alert => "Access denied."
    end
  end
end
