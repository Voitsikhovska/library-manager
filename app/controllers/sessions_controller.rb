class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: "Logged out successfully."
  end

  private

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
