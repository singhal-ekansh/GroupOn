class UsersController < ApplicationController
<<<<<<< HEAD

  before_action :already_authenticated, only: [:new, :create]
  skip_before_action :authentication_required,  except: [:show, :edit, :update]
=======
  before_action :authenticate, only: [:show, :edit, :update]
  before_action :ensure_anonymous, except: [:show, :edit, :update]
>>>>>>> locations_model

  def new
    @user = User.new
  end

  def show
    @user = current_user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path, notice: "verify email address to login by clicking link send to your email"
    else
      render :new
    end

  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user&.update(user_params)
      redirect_to @user, notice: "Profile updated"
    else
      render :edit
    end
  end


  def verify_user
    token = params[:token]
    user = User.find_signed!(token, purpose: 'email_verification')
    redirect_back(fallback: root_url) and return if user.verified_at

    if user.update(verified_at: Time.now)
      redirect_to new_session_url, notice: 'email verified, login to continue'
    else
      redirect_to new_session_url, alert: 'email could not be verified'
    end

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_session_url, alert: 'email verify link expired'
  end

 
  private def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end
end
