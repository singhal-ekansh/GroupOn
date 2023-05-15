class SessionsController < ApplicationController

  before_action :already_authenticated, except: [:destroy]
  skip_before_action :authentication_required

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      unless user.verified_at
        redirect_to new_session_url, alert: "email not verified, click on the link sent to your email"
      else
        session[:user_id] = user.id
        debugger
      # redirect_to 
      end
    else
      redirect_to new_session_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    
  end

end
