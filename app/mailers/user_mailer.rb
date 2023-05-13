class UserMailer < ApplicationMailer
  default from: "from@example.com"
  def email_verification(user)
    @token = user.signed_id(purpose: 'email_verification', expires_in: 5.minutes)
    mail to: user.email, subject: 'GroupOn register verification'
  end

  def reset_password(user)
    @token = user.signed_id(purpose: 'reset_password', expires_in: 5.minutes)
    mail to: user.email, subject: 'GroupOn account recovery'
  end
end
