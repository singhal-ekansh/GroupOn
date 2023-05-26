class SessionsController < ApplicationController

  before_action :anonymous_user_only, except: [:destroy]
  skip_before_action :authentication

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect_to //TODO
    else
      redirect_to new_session_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url, notice: 'logged out successfully'
  end

end
