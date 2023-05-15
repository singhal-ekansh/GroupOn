class ApplicationController < ActionController::Base

  before_action :authentication_required

  def authentication_required
    unless User.find_by(id: session[:user_id])
      redirect_to new_session_url, alert: 'Login to continue'
    end
  end

  def already_authenticated
    if User.find_by(id: session[:user_id])
      # redirect_to , alert: 'Already logged in'
    end
  end
end
