class User < ApplicationRecord

  enum :role, [:user, :merchant, :admin]
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "syntax is not valid"
  }, allow_blank: true

  has_secure_password
  has_many :deals, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error
  has_many :coupons, through: :orders
  has_many :reviews, dependent: :destroy
  has_many :merchant_deals, class_name: 'Deal', foreign_key: :merchant_id
  has_many :reviewed_deals, through: :reviews, source: :reviewable, source_type: 'Deal'
  
  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, update_only: true, allow_destroy: true, reject_if: ->(attr) { !attr.key?('file') }

  after_create :generate_verify_token, unless: :is_admin?
  after_create_commit :send_verification_email, unless: :is_admin?

  scope :verified, -> { where.not(verified_at: nil) }
  scope :most_spenders, -> { joins(:orders).where(orders: { status: :processed }).group(:id).order("sum(orders.amount) desc").select(:id, :first_name, :last_name, 'sum(orders.amount) as spending') }
  
  def generate_verify_token
    @token = signed_id(purpose: 'email_verification', expires_in: VERIFY_EXPIRE_TIME)
  end

  def generate_reset_password_token
    @token = signed_id(purpose: 'reset_password', expires_in: RESET_EXPIRE_TIME)
  end

  def send_verification_email
    UserMailer.email_verification(self, @token).deliver_later
  end

  def send_reset_password_mail
    UserMailer.reset_password(self, @token).deliver_later
  end

  def create_reset_password_mail
    generate_reset_password_token
    send_reset_password_mail
  end

  def is_admin?
    self.is_admin
  end

end
