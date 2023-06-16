class Coupon < ApplicationRecord
  has_secure_token :code, length: 12
  before_validation :generate_code

  belongs_to :order
end