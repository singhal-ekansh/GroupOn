class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path
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

# renders enter email to get reset link
  def forget_password_get
  end

# sends reset link
  def forget_password_post
    user = User.find_by!(email: params[:email])
    UserMailer.reset_password(user).deliver_later
    redirect_to new_session_url, notice: 'reset password link is sent to your email'

  rescue ActiveRecord::RecordNotFound
    redirect_to reset_password_email_url, alert: 'invalid email address'
  end

# renders password reset form
  def reset_password_get
    token = params[:token]
    @user = User.find_signed!(token, purpose: 'reset_password') if token
    
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_url, alert: 'reset password link expired!'
  end

#reset password form post
  def reset_password_post
    @user = User.find_signed(params[:token], purpose: "update_password")
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to new_session_url, notice: 'password has been reset successfully. Login to continue'
    else
      # handle if password and confirm not matched
      flash.now[:alert] = 'password did not match'
      render :reset_password_get
    end
  end


  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end
end
