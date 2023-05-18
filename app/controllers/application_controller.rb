class ApplicationController < ActionController::Base

  before_action :authentication_required

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authentication_required
    unless current_user
      redirect_to new_session_url, alert: 'Login to continue'
    end
  end

  def already_authenticated
    if current_user
      redirect_to user_url(session[:user_id]), alert: 'Already logged in'
    end
  end
end
