class UserMailer < ApplicationMailer
  default from: "from@example.com"
  def email_verification(user)
    @token = user.signed_id(purpose: 'email_verification', expires_in: 2.minutes)
    mail to: user.email, subject: 'GroupOn register verification'
  end
end
