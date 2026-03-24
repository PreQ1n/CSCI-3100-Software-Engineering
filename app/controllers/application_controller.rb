class ApplicationController < ActionController::Base
  helper_method :logged_in?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def logged_in?
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    @current_user.present?
  end

  def user_authentication
    if !logged_in?
      redirect_to login_path, alert: "Please first Log in"
    end
  end
end
