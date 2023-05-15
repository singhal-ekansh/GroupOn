class RequestPasswordsController < ApplicationController
  def new
  end

# sends reset link
  def create
    user = User.find_by!(email: params[:email])
    UserMailer.reset_password(user).deliver_later
    redirect_to new_session_url, notice: 'reset password link is sent to your email'

  rescue ActiveRecord::RecordNotFound
    redirect_to new_request_password_url, alert: 'invalid email address'
  end
end