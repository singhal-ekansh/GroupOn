class ResetPasswordsController < ApplicationController
  def new
    token = params[:token]
    @user = User.find_signed!(token, purpose: 'reset_password') if token
    
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_url, alert: 'reset password link expired!'
  end

  def create
    @user = User.find_signed(params[:token], purpose: "update_password")
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to new_session_url, notice: 'password has been reset successfully. Login to continue'
    else
      # handle if password and confirm not matched
      flash.now[:alert] = 'password did not match'
      render :reset_password_get
    end
  end


end