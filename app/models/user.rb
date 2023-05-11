class User < ApplicationRecord
<<<<<<< HEAD
  validates :first_name, :lastname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "syntax is not valid"
  }, allow_blank: true

=======
>>>>>>> b91a592 (users model schema)
  has_secure_password
end
