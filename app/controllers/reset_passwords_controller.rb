class ResetPasswordsController < ApplicationController
  before_action :ensure_anonymous
  def new
  end

  def create
    @user = User.find_signed!(params[:token], purpose: "reset_password")
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to new_session_url, notice: 'password has been reset successfully. Login to continue'
    else
      flash.now[:alert] = 'something went wrong'
      render :new
    end

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_url, alert: 'reset password link expired!'
  end
end