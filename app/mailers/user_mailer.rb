class UserMailer < ApplicationMailer
  
  def email_verification(user, token)
    @token = token
    mail to: user.email, subject: 'GroupOn register verification'
  end

  def reset_password(user, token)
    @token = token
    mail to: user.email, subject: 'GroupOn account recovery'
  end

  def send_referral(referral, token)
    @token = token
    mail to: user.referee_email, subject: 'GroupOn Deal Referral'
  end
end
