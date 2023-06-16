class ApplicationController < ActionController::Base


  private def current_user
    if session[:user_id]
      @current_user ||= User.verified.find_by(id: session[:user_id])
    else
      nil
    end
  end

  private def signed_in?
    !!current_user
  end

  private def authenticate
    if !signed_in?
      redirect_to new_session_url, alert: 'Login to continue'
    end
  end

  private def ensure_anonymous
    if signed_in?
      redirect_back fallback_location: root_path , alert: 'Already logged in'
    end
  end

end
