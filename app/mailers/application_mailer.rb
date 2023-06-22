class ApplicationMailer < ActionMailer::Base
  default from: DEFAULT_MAIL
  layout "mailer"
end
