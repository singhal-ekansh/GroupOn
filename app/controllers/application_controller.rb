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

<<<<<<< HEAD
  def already_authenticated
    if current_user
      # redirect_to , alert: 'Already logged in'
=======
  private def ensure_anonymous
    if signed_in?
      redirect_back fallback_location: (request.referrer || root_url) , alert: 'Already logged in'
>>>>>>> main
    end
  end
end
