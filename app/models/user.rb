class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "syntax is not valid"
  }, allow_blank: true

  has_secure_password

  # after_create :generate_verify_token
  after_create_commit :send_verification_email

  scope :verified_users, -> { where.not(verified_at: nil) }
  
  def generate_verify_token
    signed_id(purpose: 'email_verification', expires_in: VERIFY_EXPIRE_TIME)
  end

  def generate_reset_password_token
    signed_id(purpose: 'reset_password', expires_in: RESET_EXPIRE_TIME)
  end

  def send_verification_email
    UserMailer.email_verification(self).deliver_later unless is_admin
  end

  def send_reset_password_mail
    UserMailer.reset_password(self).deliver_later
  end

end
