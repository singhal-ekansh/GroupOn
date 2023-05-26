class RequestPasswordsController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :generate_token, only: [:create]
  def new
  end

# sends reset link
  def create
    if User.verified.include?(@user)
      @user.send_reset_password_mail(@token)
      redirect_to root_url, notice: 'reset password link is sent to your email'
    else
      redirect_to new_request_password_url, alert: 'invalid email address'
    end 
  end 

  private def set_user
    @user = User.find_by(email: params[:email])  
  end

  private def generate_token
    if @user 
      @token = @user.generate_reset_password_token
    end
  end
end