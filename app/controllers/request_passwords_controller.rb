class RequestPasswordsController < ApplicationController
  def new
  end

# sends reset link
  def create
    user = User.find_by(email: params[:email])
    if User.verified_users.include?(user)
      user.send_reset_password_mail
      redirect_to root_url, notice: 'reset password link is sent to your email'
    else
      redirect_to new_request_password_url, alert: 'invalid email address'
    end 
  end 
end