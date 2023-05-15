class RequestPasswordsController < ApplicationController
  def new
  end

# sends reset link
  def create
    user = User.find_by!(email: params[:email])
    if user.verified_at
      User.send_reset_password_mail(user)
      redirect_to new_session_url, notice: 'reset password link is sent to your email'
    else
      redirect_to new_session_url, alert: 'email not verified, verify to update password'
    end  

  rescue ActiveRecord::RecordNotFound
    redirect_to new_request_password_url, alert: 'invalid email address'
  end
end