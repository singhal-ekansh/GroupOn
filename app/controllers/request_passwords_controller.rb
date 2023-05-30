class RequestPasswordsController < ApplicationController

  def new
  end

# sends reset link
  def create
    @user = User.verified.find_by(email: params[:email])
    if @user
      @user.create_reset_password_mail
      redirect_to root_url, notice: 'reset password link is sent to your email'
    else
      redirect_to new_request_password_url, alert: 'invalid email address'
    end 
  end 

end