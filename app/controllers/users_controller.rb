class UsersController < ApplicationController
  before_action :set_user, only: [ :show ]
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
