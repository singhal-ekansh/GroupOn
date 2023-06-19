class Coupon < ApplicationRecord
  has_secure_token :code, length: 12
  belongs_to :order
end