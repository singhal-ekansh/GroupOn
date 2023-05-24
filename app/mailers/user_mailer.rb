class UserMailer < ApplicationMailer
  default from: "from@example.com"
  def email_verification(user, token)
    @token = token
    mail to: user.email, subject: 'GroupOn register verification'
  end

  def reset_password(user, token)
    @token = token
    mail to: user.email, subject: 'GroupOn account recovery'
  end
end
