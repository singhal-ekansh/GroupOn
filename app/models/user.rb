class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "syntax is not valid"
  }
end
