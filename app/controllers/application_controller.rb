class ApplicationController < ActionController::Base

  before_action :authentication_required

  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

  def authentication_required
    unless @user
      redirect_to new_session_url, alert: 'Login to continue'
    end
  end

  def already_authenticated
    if @user
      # redirect_to , alert: 'Already logged in'
    end
  end
end
