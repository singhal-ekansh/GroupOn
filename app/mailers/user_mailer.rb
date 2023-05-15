class UserMailer < ApplicationMailer
  default from: "from@example.com"
  def email_verification(user)
    @token = User.generate_verify_token(user)
    mail to: user.email, subject: 'GroupOn register verification'
  end

  def reset_password(user)
    @token = User.generate_reset_password_token(user)
    mail to: user.email, subject: 'GroupOn account recovery'
  end
end
