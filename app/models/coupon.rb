class Coupon < ApplicationRecord
  has_secure_token :code, length: 24
  belongs_to :order
end