class SessionsController < ApplicationController

  before_action :ensure_anonymous, except: [:destroy]
  before_action :authenticate, only: [:destroy]

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Successfully logged in'
    else
      redirect_to new_session_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url, notice: 'logged out successfully'
  end

end
