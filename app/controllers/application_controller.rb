class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include SessionsHelper


  def check_resource_ownership(resource, redirect_path, message = "Not authorized")
    redirect_to redirect_path, alert: message unless resource.user == current_user
  end
end
