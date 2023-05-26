class ApplicationController < ActionController::Base

  before_action :authentication_required

  private def current_user
    @current_user ||= session[:user_id] && User.verified.find_by(id: session[:user_id])
  end

  private def signed_in?
    current_user
  end

  private def authentication_required
    unless signed_in?
      redirect_to new_session_url, alert: 'Login to continue'
    end
  end

  private def already_authenticated
    if signed_in?
      # redirect_to , alert: 'Already logged in'
    end
  end
end
