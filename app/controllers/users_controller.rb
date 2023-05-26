class UsersController < ApplicationController

  before_action :anonymous_user_only
  skip_before_action :authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path, notice: "verify email address to login by clicking link send to your email"
    else
      render :new
    end

  end

  def verify_user
    token = params[:token]
    user = User.find_signed!(token, purpose: 'email_verification')
    if user.update(verified_at: Time.now)
      redirect_to new_session_url, notice: 'email verified, login to continue'
    else
      redirect_to new_session_url, alert: 'email could not be verified'
    end

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_url, alert: 'email verify link expired'
  end


  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end
end
