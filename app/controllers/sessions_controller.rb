class SessionsController < ApplicationController

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

end
