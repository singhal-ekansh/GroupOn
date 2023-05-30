class ApplicationController < ActionController::Base


  private def current_user
    if !@current_user && session[:user_id]
      @current_user = User.verified.find_by(id: session[:user_id])
    end
    @current_user
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
      redirect_back fallback_location: (request.referrer || root_url) , alert: 'Already logged in'
    end
  end
end
