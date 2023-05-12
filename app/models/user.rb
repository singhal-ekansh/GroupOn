class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "syntax is not valid"
  }, allow_blank: true

  has_secure_password

  after_create_commit :send_verification_email

  private

  def send_verification_email
    UserMailer.email_verification(self).deliver_later unless is_admin
  end
end
